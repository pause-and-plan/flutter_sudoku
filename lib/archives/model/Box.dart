import 'package:flutter/cupertino.dart';
import 'package:sudoku/constants.dart';
import 'package:flutter/material.dart';

class BoxPresenter {
  final int soluceSymbol;
  final bool editable;
  List<bool> listOfAnnotation = List.filled(9, false);
  int puzzleSymbol;
  bool focusEnable = false;
  bool checkEnable = false;
  bool annotationsEnable = false;

  BoxPresenter({
    required this.soluceSymbol,
    required this.editable,
    this.puzzleSymbol = SYMBOL_EMPTY,
  });

  bool hasSymbol() => puzzleSymbol != SYMBOL_EMPTY;

  void applySoluce() => puzzleSymbol = soluceSymbol;
  void toggleFocus() => focusEnable = !focusEnable;
  void toggleCheck() => checkEnable = !checkEnable;
  void toggleAnnotations() => annotationsEnable = !annotationsEnable;

  bool shouldShowAnnotations() => !hasSymbol() && annotationsEnable;

  bool shouldElevateSymbolButton(int symbol) {
    if (focusEnable == false) return false;
    if (shouldShowAnnotations()) {
      return listOfAnnotation[symbol - 1];
    } else {
      return (hasSymbol() && puzzleSymbol == symbol);
    }
  }

  void reset() {
    listOfAnnotation = List.filled(9, false);
    puzzleSymbol = SYMBOL_EMPTY;
    focusEnable = false;
    checkEnable = false;
    annotationsEnable = false;
  }

  bool shouldCheckSoluce(bool globalCheckEnable) {
    if (editable && (globalCheckEnable || checkEnable) && hasSymbol()) {
      return true;
    }
    return false;
  }

  bool isSymbolValid() => puzzleSymbol == soluceSymbol;

  Color getBackgroundColor(bool globalCheckEnable) {
    if (editable == false) {
      return Colors.black87;
    } else if (shouldCheckSoluce(globalCheckEnable)) {
      return isSymbolValid() ? Colors.green : Colors.red;
    } else {
      return Colors.black54;
    }
  }
}
