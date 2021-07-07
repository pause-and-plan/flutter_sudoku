import 'package:sudoku/constants.dart';

class BoxGenerator {
  List<int> listOfAvailableSymbol = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> listOfUnavailableSymbol = [];
  int symbol = SYMBOL_EMPTY;
  bool editable = true;

  BoxGenerator();
  BoxGenerator.shuffle() {
    listOfAvailableSymbol..shuffle();
  }
}

enum GridLevel { beginner, easy, medium, advanced, expert }

enum GridGeneratorStatus {
  none,
  inProgress,
  finished,
}

class GridGenerator {
  late List<BoxGenerator> filledGrid;
  late List<BoxGenerator> puzzleGrid;
  late GridLevel level;
  Function onChangeStatus =
      (GridGeneratorStatus status, double progressInPercent) => {};
  GridGeneratorStatus status = GridGeneratorStatus.none;
  double progressInPercent = 0; // [0 - 1]

  GridGenerator();

  void newGrid(GridLevel level, Function onChangeStatus) {
    _updateStatus(GridGeneratorStatus.inProgress);
    _initGridGenerator(level, onChangeStatus);
    _generateFilledGrid();
    _setGridNoEditable(filledGrid);
    _puzzlifyGrid();
    _updateStatus(GridGeneratorStatus.finished);
  }

  void _updateStatus(GridGeneratorStatus nextStatus) {
    status = nextStatus;
    onChangeStatus(status, progressInPercent);
  }

  void _updatePercent(double percent) {
    progressInPercent = percent;
    onChangeStatus(status, progressInPercent);
  }

  void _initGridGenerator(GridLevel level, Function onChangeStatus) {
    this.level = level;
    this.onChangeStatus = onChangeStatus;
    this.filledGrid = List.generate(81, (index) => BoxGenerator.shuffle());
    this.puzzleGrid = List.generate(81, (index) => BoxGenerator());
  }

  void _generateFilledGrid() {
    int index = 0;
    while (0 <= index && index < GRID_LENGTH) {
      try {
        _resolveThisBox(filledGrid, index);
        index++;
      } catch (error) {
        _resetBoxAtIndex(filledGrid, index);
        index--;
      }
    }
  }

  void _setGridNoEditable(List<BoxGenerator> grid) {
    for (BoxGenerator box in grid) {
      box.editable = false;
    }
  }

  void _puzzlifyGrid() {
    List<int> availableBoxIndex = _getListOfAvailableBoxIndex();
    int initialListLength = availableBoxIndex.length;

    int pickNextIndex() {
      int pickedIndex = availableBoxIndex[0];
      availableBoxIndex.removeAt(0);
      return pickedIndex;
    }

    while (availableBoxIndex.isNotEmpty) {
      _updatePercent(availableBoxIndex.length / initialListLength);
      int pickedIndex = pickNextIndex();
      try {
        filledGrid[pickedIndex].editable = true;
        _copyFilledGridInPuzzleGrid();
        _tryToValidatePuzzleGrid();
      } catch (error) {
        filledGrid[pickedIndex].editable = false;
      }
    }
    _copyFilledGridInPuzzleGrid();
  }

  List<int> _getListOfAvailableBoxIndex() {
    List<int> availableBoxIndex = List.generate(GRID_LENGTH, (index) => index)
      ..shuffle();
    switch (level) {
      case GridLevel.beginner:
        {
          return availableBoxIndex.sublist(50);
        }
      case GridLevel.easy:
        {
          return availableBoxIndex.sublist(40);
        }
      case GridLevel.medium:
        {
          return availableBoxIndex.sublist(30);
        }
      case GridLevel.advanced:
        {
          return availableBoxIndex.sublist(20);
        }
      case GridLevel.expert:
        {
          return availableBoxIndex.sublist(0);
        }
    }
  }

  void _copyFilledGridInPuzzleGrid() {
    bool shouldResetBox(int index) {
      return filledGrid[index].editable;
    }

    for (int index = 0; index < GRID_LENGTH; index++) {
      if (shouldResetBox(index)) {
        _resetBoxAtIndex(puzzleGrid, index);
      } else {
        puzzleGrid[index].symbol = filledGrid[index].symbol;
        puzzleGrid[index].editable = false;
      }
    }
  }

  void _tryToValidatePuzzleGrid([bool optimized = true]) {
    int index = 0;
    int indexStep = 1;
    int amountOfSoluces = 0;

    bool isIndexExceedGridLength() => index >= GRID_LENGTH;

    while (index >= 0) {
      if (isIndexExceedGridLength()) {
        amountOfSoluces++;
        if (optimized && amountOfSoluces > 1) {
          throw ('Invalid sudoku: amount of soluce > 1');
        }
        indexStep = -1;
      } else if (_canResolveThisBox(puzzleGrid, index)) {
        try {
          _resolveThisBox(puzzleGrid, index);
          indexStep = 1;
        } catch (error) {
          _resetBoxAtIndex(puzzleGrid, index);
          indexStep = -1;
        }
      }
      index += indexStep;
    }
  }

  bool _canResolveThisBox(List<BoxGenerator> grid, index) {
    return grid[index].editable;
  }

  void _resolveThisBox(grid, index) {
    while (_canResolveBoxWithAvailableSymbol(grid, index)) {
      int symbol = _pickSymbolInAvailableList(grid, index);
      if (_canSetBoxSymbol(grid, index, symbol)) {
        grid[index].symbol = symbol;
        return;
      }
    }
    throw ('No one available symbol can be set at this index');
  }

  bool _canResolveBoxWithAvailableSymbol(List<BoxGenerator> grid, int index) {
    BoxGenerator box = grid[index];
    if (box.listOfAvailableSymbol.isEmpty) return false;
    return true;
  }

  int _pickSymbolInAvailableList(List<BoxGenerator> grid, int index) {
    BoxGenerator box = grid[index];
    int symbol = box.listOfAvailableSymbol[0];
    box.listOfUnavailableSymbol.add(symbol);
    box.listOfAvailableSymbol.remove(symbol);
    return symbol;
  }

  bool _canSetBoxSymbol(List<BoxGenerator> grid, int index, int symbol) {
    List<int> otherBoxIndexInRegions = [];
    otherBoxIndexInRegions.addAll(_getIndexListOfBoxInSameRow(index));
    otherBoxIndexInRegions.addAll(_getIndexListOfBoxInSameColumn(index));
    otherBoxIndexInRegions.addAll(_getIndexListOfBoxInSameBlock(index));
    for (int boxIndex in otherBoxIndexInRegions) {
      if (grid[boxIndex].symbol == symbol) {
        return false;
      }
    }
    return true;
  }

  void _resetBoxAtIndex(List<BoxGenerator> grid, index) {
    grid[index] = BoxGenerator();
  }

  List<int> _getIndexListOfBoxInSameRow(int index) {
    int rowIndex = (index / GRID_SIZE).floor();
    int rowStartIndex = rowIndex * GRID_SIZE;
    int rowEndIndex = rowStartIndex + GRID_SIZE;
    List<int> indexInSameRow = [];

    for (int currIndex = rowStartIndex; currIndex < rowEndIndex; currIndex++) {
      if (currIndex != index) {
        indexInSameRow.add(currIndex);
      }
    }
    return indexInSameRow;
  }

  List<int> _getIndexListOfBoxInSameColumn(int index) {
    int columnIndex = index % GRID_SIZE;
    List<int> indexInSameColumn = [];

    for (int i = 0; i < GRID_SIZE; i++) {
      int currIndex = columnIndex + (i * GRID_SIZE);
      if (currIndex != index) {
        indexInSameColumn.add(currIndex);
      }
    }
    return indexInSameColumn;
  }

  List<int> _getIndexListOfBoxInSameBlock(int index) {
    int blocStartColumIndex = ((index % GRID_SIZE) / 3).floor() * 3;
    int blocStartRowIndex = (((index / GRID_SIZE).floor()) / 3).floor() * 3;
    List<int> indexInSameBlock = [];

    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        int currRowIndex = blocStartRowIndex + y;
        int currColumnIndex = blocStartColumIndex + x;
        int currIndex = currRowIndex * GRID_SIZE + currColumnIndex;
        if (currIndex != index) {
          indexInSameBlock.add(currIndex);
        }
      }
    }
    return indexInSameBlock;
  }
}
