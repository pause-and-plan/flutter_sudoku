import '../helpers/grid.dart';
import '../models/box_model.dart';
import '../models/symbol_model.dart';

class GridDebugger {
  late List<Symbol> _symbolList;
  String _currRow = '';

  GridDebugger({required List<Symbol> symbolList}) {
    this._symbolList = symbolList;
  }
  GridDebugger.boxList(List<BoxPuzzled> boxList) {
    this._symbolList = boxList.map((BoxPuzzled box) => box.symbol).toList();
  }
  GridDebugger.clean(List<BoxPuzzled> boxList) {
    this._symbolList = boxList.map((BoxPuzzled box) {
      if (box.editable) return Symbol.none();
      return box.symbol;
    }).toList();
  }

  debug() {
    _debugRow(_symbolList.sublist(Grid.size * 0, Grid.size * 1));
    _debugRow(_symbolList.sublist(Grid.size * 1, Grid.size * 2));
    _debugRow(_symbolList.sublist(Grid.size * 2, Grid.size * 3));
    print(' - - - - - - - - - - -');
    _debugRow(_symbolList.sublist(Grid.size * 3, Grid.size * 4));
    _debugRow(_symbolList.sublist(Grid.size * 4, Grid.size * 5));
    _debugRow(_symbolList.sublist(Grid.size * 5, Grid.size * 6));
    print(' - - - - - - - - - - -');
    _debugRow(_symbolList.sublist(Grid.size * 6, Grid.size * 7));
    _debugRow(_symbolList.sublist(Grid.size * 7, Grid.size * 8));
    _debugRow(_symbolList.sublist(Grid.size * 8, Grid.size * 9));
  }

  _debugRow(List<Symbol> row) {
    _currRow = '';
    row.sublist(0, 3).forEach(_addSymbolInFormatedRow);
    _currRow += " |";
    row.sublist(3, 6).forEach(_addSymbolInFormatedRow);
    _currRow += " |";
    row.sublist(6, 9).forEach(_addSymbolInFormatedRow);
    print(_currRow);
  }

  _addSymbolInFormatedRow(Symbol symbol) {
    _currRow += " ";
    _currRow += symbol.toString();
  }
}
