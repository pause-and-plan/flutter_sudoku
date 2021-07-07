import 'package:sudoku_v2/sudoku/grid_provider/box_model.dart';

class Grid {
  /// variables
  static const size = 9;
  static const length = 81;
  List<Box> boxList = List.filled(size, Box.initial());

  /// initialization
  Grid({required this.boxList});

  Grid.empty() {
    boxList = List.filled(length, Box.initial());
  }

  /// Box getter/setter
  void updateBoxSymbol(index, symbol) {
    boxList[index] = boxList[index].copyWith(symbol: symbol);
  }

  void resetBox(int index) {
    boxList[index] = Box(availableSymbols: Symbols.list()..shuffle());
  }

  Box getBox(index) => boxList[index];

  /// utility methods
  Grid copy() {
    List<Box> copyList = [];
    for (Box box in boxList) {
      Box boxCopy = box.copyWith();
      copyList.add(boxCopy);
    }
    return Grid(boxList: copyList);
  }

  /// static methods
  static List<int> getIndexListOfBoxInSameRow(int index) {
    int rowIndex = (index / Grid.size).floor();
    int rowStartIndex = rowIndex * Grid.size;
    int rowEndIndex = rowStartIndex + Grid.size;
    List<int> indexInSameRow = [];

    for (int currIndex = rowStartIndex; currIndex < rowEndIndex; currIndex++) {
      if (currIndex != index) {
        indexInSameRow.add(currIndex);
      }
    }
    return indexInSameRow;
  }

  static List<int> getIndexListOfBoxInSameColumn(int index) {
    int columnIndex = index % Grid.size;
    List<int> indexInSameColumn = [];

    for (int i = 0; i < Grid.size; i++) {
      int currIndex = columnIndex + (i * Grid.size);
      if (currIndex != index) {
        indexInSameColumn.add(currIndex);
      }
    }
    return indexInSameColumn;
  }

  static List<int> getIndexListOfBoxInSameBlock(int index) {
    int blocStartColumIndex = ((index % Grid.size) / 3).floor() * 3;
    int blocStartRowIndex = (((index / Grid.size).floor()) / 3).floor() * 3;
    List<int> indexInSameBlock = [];

    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        int currRowIndex = blocStartRowIndex + y;
        int currColumnIndex = blocStartColumIndex + x;
        int currIndex = currRowIndex * Grid.size + currColumnIndex;
        if (currIndex != index) {
          indexInSameBlock.add(currIndex);
        }
      }
    }
    return indexInSameBlock;
  }

  debugAmountOfPuzzle() {
    int amount = 0;
    for (Box box in boxList) {
      if (box.isPuzzle) amount++;
    }
    print(' amount of puzzle $amount');
  }
}

class GridDebugger {
  List<Box> listOfBox = List.filled(81, Box.initial());

  GridDebugger(List<Box> grid) {
    this.listOfBox = grid;
  }

  void debugCurrentGrid() {
    debugGrid(listOfBox, debugRow, extractBoxTrueSymbol);
  }

  static void debugGrid(
      List<Box> listOfBox, Function callback, Function extractSymbol) {
    debugRow(listOfBox.sublist(Grid.size * 0, Grid.size * 1), extractSymbol);
    debugRow(listOfBox.sublist(Grid.size * 1, Grid.size * 2), extractSymbol);
    debugRow(listOfBox.sublist(Grid.size * 2, Grid.size * 3), extractSymbol);
    print(' - - - - - - - - - - -');
    debugRow(listOfBox.sublist(Grid.size * 3, Grid.size * 4), extractSymbol);
    debugRow(listOfBox.sublist(Grid.size * 4, Grid.size * 5), extractSymbol);
    debugRow(listOfBox.sublist(Grid.size * 5, Grid.size * 6), extractSymbol);
    print(' - - - - - - - - - - -');
    debugRow(listOfBox.sublist(Grid.size * 6, Grid.size * 7), extractSymbol);
    debugRow(listOfBox.sublist(Grid.size * 7, Grid.size * 8), extractSymbol);
    debugRow(listOfBox.sublist(Grid.size * 8, Grid.size * 9), extractSymbol);
    print('\n\n\n');
  }

  static void debugRow(List<Box> row, Function extractSymbol) {
    String formatedRow = '';
    void addSymbolInFormatedRow(Box box) {
      int symbol = extractSymbol(box);
      formatedRow += " ";
      if (symbol == 0)
        formatedRow += " ";
      else
        formatedRow += symbol.toString();
    }

    row.sublist(0, 3).forEach(addSymbolInFormatedRow);
    formatedRow += " |";
    row.sublist(3, 6).forEach(addSymbolInFormatedRow);
    formatedRow += " |";
    row.sublist(6, 9).forEach(addSymbolInFormatedRow);

    print(formatedRow);
  }

  static int extractBoxCurrentSymbol(Box box) {
    return box.symbol;
  }

  static int extractBoxTrueSymbol(Box box) {
    return box.symbol;
  }
}
