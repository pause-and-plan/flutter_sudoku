import 'dart:collection';
import 'package:sudoku/constants.dart';
import 'package:sudoku/model/Box.dart';
import 'package:sudoku/presenter/initializeGrid.dart';

import 'package:flutter/material.dart';

class GamePresenter extends ChangeNotifier {
  List<BoxPresenter> _grid = [];
  int currentBoxIndex = 0;
  bool globalCheckEnable = false;

  UnmodifiableListView<BoxPresenter> get grid => UnmodifiableListView(_grid);
  BoxPresenter get currentBox => _grid[currentBoxIndex];

  GamePresenter();
  GamePresenter.reset() {
    reset();
  }

  void reset() {
    _grid = initializeGrid(LEVEL_EXPERT);
    currentBoxIndex = 0;
    globalCheckEnable = false;
    notifyListeners();
  }

  void undo() {}
  void redo() {}

  void toggleGlobalCheck() {
    globalCheckEnable = !globalCheckEnable;
    notifyListeners();
  }

  String getSymbol(int index) {
    if (grid[index].soluceEnable) {
      return grid[index].soluceSymbol.toString();
    } else if (grid[index].hasSymbol()) {
      return grid[index].puzzleSymbol.toString();
    } else {
      return '';
    }
  }

  bool isBoxEditable(int index) {
    return !grid[index].editable;
  }

  void setCurrentBoxSymbol(int symbol) {
    if (currentBox.puzzleSymbol == symbol) {
      currentBox.puzzleSymbol = SYMBOL_EMPTY;
    } else {
      currentBox.puzzleSymbol = symbol;
    }
    notifyListeners();
  }

  void currentBoxToggleFocus() {
    currentBox.toggleFocus();
    notifyListeners();
  }

  void currentBoxToggleCheck() {
    currentBox.toggleCheck();
    notifyListeners();
  }

  void currentBoxToggleSoluce() {
    currentBox.toggleSoluce();
    notifyListeners();
  }

  void currentBoxToggleAnnotations() {
    currentBox.toggleAnnotations();
    notifyListeners();
  }

  void changeCurrentBoxIndex(int index) {
    if (grid[index].editable) {
      currentBox.focusEnable = false;
      currentBoxIndex = index;
      currentBoxToggleFocus();
      notifyListeners();
    }
  }
}
