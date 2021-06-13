import 'package:sudoku/constants.dart';

class BoxPresenter {
  final int soluceSymbol;
  final bool editable;
  List<bool> listOfAnnotation = List.filled(9, false);
  int puzzleSymbol;
  bool focusEnable = false;
  bool checkEnable = false;
  bool soluceEnable = false;
  bool annotationsEnable = false;

  BoxPresenter({
    required this.soluceSymbol,
    required this.editable,
    this.puzzleSymbol = SYMBOL_EMPTY,
  });

  bool hasSymbol() => puzzleSymbol != SYMBOL_EMPTY;
  int getSymbol() => soluceEnable ? soluceSymbol : puzzleSymbol;

  void toggleFocus() => focusEnable = !focusEnable;
  void toggleCheck() => checkEnable = !checkEnable;
  void toggleSoluce() => soluceEnable = !soluceEnable;
  void toggleAnnotations() => annotationsEnable = !annotationsEnable;
  bool shouldElevateSymbolButton(int index) {
    return puzzleSymbol == index && hasSymbol();
  }
}
