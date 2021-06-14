import 'dart:collection';
import 'package:sudoku/constants.dart';
import 'package:sudoku/model/Box.dart';
import 'package:sudoku/presenter/initializeGrid.dart';

import 'package:flutter/material.dart';

class GamePresenter extends ChangeNotifier {
  List<BoxPresenter> _grid = [];
  int currentBoxIndex = 0;
  bool globalCheckEnable = false;
  int levelIndex = 1; // 0 beginner | 1 easy | 2 medium | 3 advanced | 4 expert
  bool loading = false;
  bool ready = false;

  UnmodifiableListView<BoxPresenter> get grid => UnmodifiableListView(_grid);

  BoxPresenter get currentBox => _grid[currentBoxIndex];

  GamePresenter();
  GamePresenter.reset() {
    newGame();
  }
  void loadingStart() {
    loading = true;
    notifyListeners();
  }

  void loadingStop() {
    loading = false;
    notifyListeners();
  }

  void newGame() {
    loadingStart();
    _grid = initializeGrid(levels[levelIndex].baseAmountOfPuzzle);
    currentBoxIndex = 0;
    globalCheckEnable = false;
    loadingStop();
  }

  void resetGrid() {
    for (BoxPresenter box in _grid) {
      if (box.editable) box.reset();
    }
    currentBoxIndex = 0;
    notifyListeners();
  }

  void onChangeLevel(int nextLevelIndex) {
    levelIndex = nextLevelIndex;
    notifyListeners();
  }

  void undo() {}
  void redo() {}

  void toggleGlobalCheck() {
    globalCheckEnable = !globalCheckEnable;
    notifyListeners();
  }

  String getSymbol(int index) {
    if (grid[index].hasSymbol()) {
      return grid[index].puzzleSymbol.toString();
    } else {
      return '';
    }
  }

  bool isBoxEditable(index) {
    return grid[index].editable;
  }

  bool canHandleBoxFocus(index) {
    return isBoxEditable(index);
  }

  bool canModifyBox(index) {
    return canHandleBoxFocus(index) && grid[index].focusEnable;
  }

  void currentBoxToggleFocus() {
    if (canHandleBoxFocus(currentBoxIndex)) {
      currentBox.toggleFocus();
      notifyListeners();
    }
  }

  void currentBoxToggleCheck() {
    if (canModifyBox(currentBoxIndex)) {
      currentBox.toggleCheck();
      notifyListeners();
    }
  }

  void currentBoxApplySoluce() {
    if (canModifyBox(currentBoxIndex)) {
      currentBox.reset();
      currentBox.applySoluce();
      notifyListeners();
    }
  }

  void currentBoxToggleAnnotations() {
    if (canModifyBox(currentBoxIndex) && currentBox.hasSymbol() == false) {
      currentBox.toggleAnnotations();
      notifyListeners();
    }
  }

  void focusBox(int index) {
    if (canHandleBoxFocus(index)) {
      currentBox.focusEnable = false;
      currentBoxIndex = index;
      currentBox.focusEnable = true;
      notifyListeners();
    }
  }

  void onPressBox(int index) {
    bool isSameBox = index == currentBoxIndex;
    if (isSameBox) {
      currentBoxToggleFocus();
    } else {
      focusBox(index);
    }
  }

  void toggleCurrentBoxSymbol(int symbol) {
    if (currentBox.puzzleSymbol == symbol) {
      currentBox.puzzleSymbol = SYMBOL_EMPTY;
    } else {
      currentBox.puzzleSymbol = symbol;
    }
  }

  void toggleCurrentBoxAnnotation(int symbol) {
    bool lastValue = currentBox.listOfAnnotation[symbol - 1];
    currentBox.listOfAnnotation[symbol - 1] = !lastValue;
  }

  bool shouldToggleAnnotations() => currentBox.annotationsEnable;

  void onPressSymbol(int symbol) {
    if (canModifyBox(currentBoxIndex)) {
      if (shouldToggleAnnotations()) {
        toggleCurrentBoxAnnotation(symbol);
      } else {
        toggleCurrentBoxSymbol(symbol);
      }
      notifyListeners();
    }
  }
}
