import 'package:flutter/material.dart';
import 'package:sudoku/constants.dart';
import 'package:sudoku/grid_generator/grid_generator.dart';

class Box {
  late int soluceSymbol;
  late bool isPuzzle;
  int puzzleSymbol = SYMBOL_EMPTY;
  bool checkEnable = false;
  bool annotationsEnable = false;
  List<bool> listOfAnnotation = List.filled(9, false);

  Box(int symbol, bool puzzle) {
    this.soluceSymbol = symbol;
    this.isPuzzle = puzzle;
    if (puzzle == false) {
      this.puzzleSymbol = symbol;
    }
  }
  Box.copy(Box box) {
    soluceSymbol = box.soluceSymbol;
    isPuzzle = box.isPuzzle;
    puzzleSymbol = box.puzzleSymbol;
    checkEnable = box.checkEnable;
    annotationsEnable = box.annotationsEnable;
    listOfAnnotation = [...box.listOfAnnotation];
  }

  reset() {
    if (isPuzzle) {
      this.puzzleSymbol = SYMBOL_EMPTY;
      checkEnable = false;
      annotationsEnable = false;
      listOfAnnotation = List.filled(9, false);
    }
  }

  isPuzzleSymbolValid() => puzzleSymbol == soluceSymbol;
  hasSymbol() => puzzleSymbol != SYMBOL_EMPTY;
}

enum GridStatus {
  empty,
  loading,
  ready,
  locked,
}

class Grid {
  List<List<Box>> history = [];
  List<Box> listOfBox = [];
  int boxIndex = NO_INDEX;
  bool globalCheckEnable = false;
  GridStatus status = GridStatus.empty;
  double loadingPercent = 0;
  late GridLevel gridLevel;

  Grid(List<Box> listOfBox, GridLevel level) {
    this.listOfBox = listOfBox;
    this.gridLevel = level;
  }
  Grid.empty() {
    this.listOfBox =
        List.generate(GRID_SIZE, (index) => Box(SYMBOL_EMPTY, false));
    this.gridLevel = GridLevel.easy;
  }

  Box get currentBox {
    if (boxIndex == NO_INDEX) return Box(SYMBOL_EMPTY, false);
    return listOfBox[boxIndex];
  }

  void toggleGlobalCheck() => globalCheckEnable = !globalCheckEnable;

  void reset() {
    for (Box box in listOfBox) {
      box.reset();
      boxIndex = NO_INDEX;
      globalCheckEnable = false;
      status = GridStatus.ready;
    }
  }

  void lock() => status = GridStatus.locked;
  void unlock() => status = GridStatus.ready;

  void removeBoxFocus() => boxIndex = NO_INDEX;
  bool canFocusBox(int index) {
    if (status == GridStatus.locked) return false;
    return listOfBox[index].isPuzzle;
  }

  void focusBox(int index) => boxIndex = index;

  bool canApplyChangeOnFocusedBox() {
    if (status == GridStatus.locked) return false;
    if (boxIndex == NO_INDEX) return false;
    if (listOfBox[boxIndex].isPuzzle == false) return false;
    return true;
  }

  void toggleSymbolOnFocusedBox(int symbol) {
    _saveInHistory();
    if (listOfBox[boxIndex].puzzleSymbol == symbol) {
      listOfBox[boxIndex].puzzleSymbol = SYMBOL_EMPTY;
    } else {
      listOfBox[boxIndex].puzzleSymbol = symbol;
    }
  }

  void toggleCheckOnFocusedBox() {
    listOfBox[boxIndex].checkEnable = !listOfBox[boxIndex].checkEnable;
  }

  void applySoluceOnFocusedBox() {
    listOfBox[boxIndex].puzzleSymbol = listOfBox[boxIndex].soluceSymbol;
  }

  void toggleAnnotationOnFocusedBox() {
    listOfBox[boxIndex].annotationsEnable =
        !listOfBox[boxIndex].annotationsEnable;
  }

  void toggleAnnotationSymbolOnFocusedBox(int symbolIndex) {
    _saveInHistory();
    List<bool> listOfAnnotation = listOfBox[boxIndex].listOfAnnotation;
    listOfAnnotation[symbolIndex] = !listOfAnnotation[symbolIndex];
  }

  _saveInHistory() {
    List<Box> save = listOfBox.map((box) => Box.copy(box)).toList();
    this.history.add(save);
  }

  previous() {
    if (history.isNotEmpty) {
      listOfBox = history.last;
      history.removeLast();
    }
  }

  bool isGridFilledWithSuccess() {
    for (Box box in listOfBox) {
      if (box.isPuzzleSymbolValid() == false) return false;
    }
    return true;
  }

  String getLevelLabel() {
    switch (gridLevel) {
      case GridLevel.beginner:
        {
          return 'Debutant';
        }
      case GridLevel.easy:
        {
          return 'Facile';
        }
      case GridLevel.medium:
        {
          return 'Moyen';
        }
      case GridLevel.advanced:
        {
          return 'Difficile';
        }
      case GridLevel.expert:
        {
          return 'Expert';
        }
    }
  }

  bool shouldShowBoxAnnotation(int index) {
    if (listOfBox[index].annotationsEnable == false) return false;
    if (listOfBox[index].hasSymbol()) return false;
    return true;
  }

  List<bool> getListOfAnnotation(int index) {
    return listOfBox[index].listOfAnnotation;
  }

  String getSymbol(int index) {
    Box box = listOfBox[index];
    if (box.hasSymbol()) {
      return box.puzzleSymbol.toString();
    }
    return ' ';
  }

  Color getSymbolColor(int index) {
    Box box = listOfBox[index];
    if (box.isPuzzle == false) {
      return Colors.black87;
    } else if (globalCheckEnable || box.checkEnable) {
      return box.isPuzzleSymbolValid() ? Colors.green : Colors.red;
    } else {
      return Colors.black54;
    }
  }

  bool shouldElevateSymbolButton(int symbol) {
    if (canApplyChangeOnFocusedBox()) {
      if (shouldShowBoxAnnotation(boxIndex)) {
        return currentBox.listOfAnnotation[symbol - 1];
      } else {
        return currentBox.puzzleSymbol == symbol;
      }
    }
    return false;
  }
}
