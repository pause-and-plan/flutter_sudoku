import 'package:sudoku/constants.dart';
import 'package:sudoku/model/Box.dart';

List<BoxPresenter> initializeGrid(int level) {
  Grid initialGrid = GridGenerator(level: level);

  List<BoxPresenter> presentationGrid = List.generate(GRID_LENGTH, (index) {
    int soluceSymbol = initialGrid.filledGrid[index].symbol;
    int puzzleSymbol = initialGrid.puzzleGrid[index].symbol;
    bool editable = initialGrid.puzzleGrid[index].editable;
    return BoxPresenter(
      soluceSymbol: soluceSymbol,
      puzzleSymbol: puzzleSymbol,
      editable: editable,
    );
  });

  return presentationGrid;
}

class Box {
  List<int> listOfAvailableSymbol = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  List<int> listOfUnavailableSymbol = [];
  int symbol = SYMBOL_EMPTY;
  bool editable = true;

  Box();
  Box.shuffle() {
    listOfAvailableSymbol..shuffle();
  }
}

class Grid {
  List<Box> filledGrid = List<Box>.generate(81, (index) => Box.shuffle());
  List<Box> puzzleGrid = List<Box>.generate(81, (index) => Box());
}

class GridGenerator extends Grid {
  GridGenerator({required int level}) {
    generateFilledGrid();
    setGridNoEditable(filledGrid);
    puzzlifyGrid(level);
  }

  void generateFilledGrid() {
    int index = 0;
    while (0 <= index && index < GRID_LENGTH) {
      try {
        resolveThisBox(filledGrid, index);
        index++;
      } catch (error) {
        resetBoxAtIndex(filledGrid, index);
        index--;
      }
    }
  }

  void setGridNoEditable(List<Box> grid) {
    for (Box box in grid) {
      box.editable = false;
    }
  }

  void puzzlifyGrid(int level) {
    List<int> availableBoxIndex = List.generate(GRID_LENGTH, (index) => index)
      ..shuffle();
    availableBoxIndex = availableBoxIndex.sublist(level);
    int pickNextIndex() {
      int pickedIndex = availableBoxIndex[0];
      availableBoxIndex.removeAt(0);
      return pickedIndex;
    }

    while (availableBoxIndex.isNotEmpty) {
      print(availableBoxIndex.length);
      int pickedIndex = pickNextIndex();
      try {
        filledGrid[pickedIndex].editable = true;
        copyFilledGridInPuzzleGrid();
        tryToValidatePuzzleGrid();
      } catch (error) {
        filledGrid[pickedIndex].editable = false;
      }
    }
    copyFilledGridInPuzzleGrid();
  }

  void copyFilledGrid(List<Box> grid) {
    bool shouldResetBox(int index) {
      return filledGrid[index].editable;
    }

    for (int index = 0; index < GRID_LENGTH; index++) {
      if (shouldResetBox(index)) {
        resetBoxAtIndex(grid, index);
      } else {
        grid[index].symbol = filledGrid[index].symbol;
        grid[index].editable = false;
      }
    }
  }

  void copyFilledGridInPuzzleGrid() {
    bool shouldResetBox(int index) {
      return filledGrid[index].editable;
    }

    for (int index = 0; index < GRID_LENGTH; index++) {
      if (shouldResetBox(index)) {
        resetBoxAtIndex(puzzleGrid, index);
      } else {
        puzzleGrid[index].symbol = filledGrid[index].symbol;
        puzzleGrid[index].editable = false;
      }
    }
  }

  void tryToValidatePuzzleGrid([bool optimized = true]) {
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
      } else if (canResolveThisBox(puzzleGrid, index)) {
        try {
          resolveThisBox(puzzleGrid, index);
          indexStep = 1;
        } catch (error) {
          resetBoxAtIndex(puzzleGrid, index);
          indexStep = -1;
        }
      }
      index += indexStep;
    }
  }

  bool canResolveThisBox(List<Box> grid, index) {
    return grid[index].editable;
  }

  void resolveThisBox(grid, index) {
    while (canTryToResolveBoxWithAvailableSymbol(grid, index)) {
      int symbol = pickSymbolInAvailableList(grid, index);
      if (canSetBoxSymbol(grid, index, symbol)) {
        grid[index].symbol = symbol;
        return;
      }
    }
    throw ('No one available symbol can be set at this index');
  }

  bool canTryToResolveBoxWithAvailableSymbol(List<Box> grid, int index) {
    Box box = grid[index];
    if (box.listOfAvailableSymbol.isEmpty) return false;
    return true;
  }

  int pickSymbolInAvailableList(List<Box> grid, int index) {
    Box box = grid[index];
    int symbol = box.listOfAvailableSymbol[0];
    box.listOfUnavailableSymbol.add(symbol);
    box.listOfAvailableSymbol.remove(symbol);
    return symbol;
  }

  static void resetBoxAtIndex(List<Box> grid, index) {
    grid[index] = Box();
  }

  static bool canSetBoxSymbol(List<Box> grid, int index, int symbol) {
    List<int> otherBoxIndexInRegions = [];
    otherBoxIndexInRegions.addAll(getIndexListOfBoxInSameRow(index));
    otherBoxIndexInRegions.addAll(getIndexListOfBoxInSameColumn(index));
    otherBoxIndexInRegions.addAll(getIndexListOfBoxInSameBloc(index));
    for (int boxIndex in otherBoxIndexInRegions) {
      if (grid[boxIndex].symbol == symbol) {
        return false;
      }
    }
    return true;
  }

  static List<int> getIndexListOfBoxInSameRow(int index) {
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

  static List<int> getIndexListOfBoxInSameColumn(int index) {
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

  static List<int> getIndexListOfBoxInSameBloc(int index) {
    int blocStartColumIndex = ((index % GRID_SIZE) / 3).floor() * 3;
    int blocStartRowIndex = (((index / GRID_SIZE).floor()) / 3).floor() * 3;
    List<int> indexInSameColumn = [];

    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        int currRowIndex = blocStartRowIndex + y;
        int currColumnIndex = blocStartColumIndex + x;
        int currIndex = currRowIndex * GRID_SIZE + currColumnIndex;
        if (currIndex != index) {
          indexInSameColumn.add(currIndex);
        }
      }
    }
    return indexInSameColumn;
  }
}
