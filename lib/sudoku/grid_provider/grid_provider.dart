import 'package:sudoku_v2/sudoku/grid_provider/box_model.dart';
import 'package:sudoku_v2/sudoku/grid_provider/grid_model.dart';

class GridBuilder {
  Grid grid;
  int _index = 0;
  Box get currBox => grid.getBox(_index);

  GridBuilder({required this.grid});

  Stream<GridBuildState> build() async* {
    yield* _buildFilledGrid();
    GridPuzzler puzzler = GridPuzzler(originalGrid: grid.copy());
    GridDebugger(grid.boxList).debugCurrentGrid();
    yield* puzzler.puzzlify();
  }

  Stream<GridBuildState> _buildFilledGrid() async* {
    _index = 0;
    while (0 <= _index && _index < Grid.length) {
      _tryResolveCurrBox();
      await Future.delayed(Duration(milliseconds: 10));
      yield GridBuildState(
        step: GridBuildStep.fillGrid,
        status: GridBuildStatus.inProgress,
        percent: ((_index / Grid.length) * 100).toInt(),
        grid: grid,
      );
    }
    yield GridBuildState(
      step: GridBuildStep.fillGrid,
      status: GridBuildStatus.complete,
      percent: 100,
      grid: grid,
    );
  }

  _tryResolveCurrBox() {
    try {
      _resolveCurrBox();
      _index++;
    } catch (error) {
      print(error);
      grid.resetBox(_index);
      _index--;
    }
  }

  void _resolveCurrBox() {
    while (currBox.availableSymbols.isNotEmpty) {
      int symbol = _pickAvailableSymbolInList();
      if (GridValidator.canSetBoxSymbol(grid.boxList, _index, symbol)) {
        grid.updateBoxSymbol(_index, symbol);
        return;
      }
    }
    throw ('No one available symbol can be set at this index');
  }

  int _pickAvailableSymbolInList() {
    int symbol = currBox.availableSymbols[0];
    currBox.availableSymbols.removeAt(0);
    return symbol;
  }
}

class GridPuzzler {
  final Grid originalGrid;
  late Grid puzzleGrid;
  DifficultyLevel level;
  List<int> _amountOfTry = List.generate(Grid.length, (index) => index)
    ..shuffle();
  int _index = 0;
  Box get originalBox => originalGrid.boxList[_index];
  set originalBox(Box box) => originalGrid.boxList[_index] = box;

  GridPuzzler({
    required this.originalGrid,
    this.level = DifficultyLevel.expert,
  });

  Stream<GridBuildState> puzzlify() async* {
    yield GridBuildState(
      status: GridBuildStatus.inProgress,
      step: GridBuildStep.puzzlify,
      grid: originalGrid,
    );
    yield* _puzzlifyGrid();
  }

  Stream<GridBuildState> _puzzlifyGrid() async* {
    _adaptAmountOfTryWithDifficulty();
    while (_amountOfTry.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 100));
      _index = _pickIndexInList();
      _tryToPuzzlifyBox();
      yield GridBuildState(
        status: GridBuildStatus.inProgress,
        step: GridBuildStep.puzzlify,
        grid: originalGrid,
      );
    }
    yield GridBuildState(
      status: GridBuildStatus.complete,
      step: GridBuildStep.puzzlify,
      grid: originalGrid,
    );
  }

  _tryToPuzzlifyBox() {
    try {
      originalBox = originalBox.copyWith(isPuzzle: true);
      _puzzlifyBox();
    } catch (error) {
      print(error);
      originalBox = originalBox.copyWith(isPuzzle: false);
    }
  }

  _puzzlifyBox() {
    puzzleGrid = originalGrid.copy();
    _cleanPuzzleGrid();
    GridResolver resolver = GridResolver(grid: puzzleGrid.copy());
    resolver.resolve();
  }

  _cleanPuzzleGrid() {
    for (int i = 0; i < Grid.length; i++) {
      if (puzzleGrid.boxList[i].isPuzzle) {
        puzzleGrid.boxList[i] = Box.initial(isPuzzle: true);
      }
    }
  }

  int _pickIndexInList() {
    int index = _amountOfTry[0];
    _amountOfTry.removeAt(0);
    return index;
  }

  _adaptAmountOfTryWithDifficulty() {
    switch (level) {
      case DifficultyLevel.beginner:
        _amountOfTry.removeRange(0, 50);
        break;
      case DifficultyLevel.easy:
        _amountOfTry.removeRange(0, 40);
        break;
      case DifficultyLevel.medium:
        _amountOfTry.removeRange(0, 30);
        break;
      case DifficultyLevel.advanced:
        _amountOfTry.removeRange(0, 20);
        break;
      case DifficultyLevel.expert:
        _amountOfTry.removeRange(0, 0);
        break;
    }
  }
}

class GridResolver {
  final Grid grid;
  int _index = 0;
  List<int> _indexList = [];
  int _soluceAmount = 0;
  int get _currIndex => _indexList[_index];
  Box get _currBox => grid.boxList[_currIndex];
  set _currBox(Box box) => grid.boxList[_currIndex] = box;

  GridResolver({required this.grid}) {
    _initializeIndexList();
  }

  _initializeIndexList() {
    for (int index = 0; index < Grid.length; index++) {
      if (grid.boxList[index].isPuzzle) {
        _indexList.add(index);
      }
    }
  }

  resolve() {
    _index = 0;
    while (_shouldContinueToSearchSolution()) {
      try {
        _resolveCurrBox();
        _index++;
      } catch (error) {
        _resetCurrBox();
        _index--;
      }
      if (_isIndexExceedAmountOfPuzzleBox()) {
        _soluceAmount++;
        _index--;
      }
    }
    if (_soluceAmount > 1) throw ('Invalid grid: soluce amount > 1');
  }

  bool _shouldContinueToSearchSolution() {
    if (_index < 0) return false;
    if (_indexList.isEmpty) return false;
    if (_soluceAmount > 1) return false;
    if (grid.boxList[_indexList[0]].availableSymbols.isEmpty) return false;
    return true;
  }

  _resetCurrBox() {
    _currBox = Box.initial(isPuzzle: true);
  }

  void _resolveCurrBox() {
    while (_currBox.availableSymbols.isNotEmpty) {
      int symbol = _pickAvailableSymbolInList();
      if (GridValidator.canSetBoxSymbol(grid.boxList, _currIndex, symbol)) {
        _currBox = _currBox.copyWith(symbol: symbol);
        return;
      }
    }
    throw ('No one available symbol can be set at this index');
  }

  int _pickAvailableSymbolInList() {
    int symbol = _currBox.availableSymbols[0];
    _currBox.availableSymbols.removeAt(0);
    return symbol;
  }

  bool _isIndexExceedAmountOfPuzzleBox() => _index >= _indexList.length;
}

class GridValidator {
  static bool canSetBoxSymbol(List<Box> grid, int index, int symbol) {
    List<int> otherBoxIndexInRegions = [];
    otherBoxIndexInRegions.addAll(Grid.getIndexListOfBoxInSameRow(index));
    otherBoxIndexInRegions.addAll(Grid.getIndexListOfBoxInSameColumn(index));
    otherBoxIndexInRegions.addAll(Grid.getIndexListOfBoxInSameBlock(index));
    for (int boxIndex in otherBoxIndexInRegions) {
      if (grid[boxIndex].symbol == symbol) {
        return false;
      }
    }
    return true;
  }
}

enum GridBuildStatus { initial, inProgress, complete }
enum GridBuildStep { initial, fillGrid, puzzlify }

class GridBuildState {
  final GridBuildStatus status;
  final GridBuildStep step;
  final int? percent;
  final Grid grid;

  GridBuildState({
    required this.status,
    required this.step,
    required this.grid,
    this.percent,
  });
}

enum DifficultyLevel { beginner, easy, medium, advanced, expert }
