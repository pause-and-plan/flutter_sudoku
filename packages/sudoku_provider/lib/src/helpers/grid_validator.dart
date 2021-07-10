import '../helpers/grid.dart';
import '../models/box_model.dart';
import '../models/symbol_model.dart';

class GridValidator {
  late List<Symbol> _symbolList;

  GridValidator({required List<Symbol> symbolList}) {
    this._symbolList = symbolList;
  }
  GridValidator.fromBoxList({required List<Box> boxList}) {
    this._symbolList = boxList.map((Box box) => box.symbol).toList();
  }

  bool isValid() {
    for (int index = 0; index < Grid.length; index++) {
      if (_symbolList[index].hasValue) {
        if (isSymbolValidAtIndex(_symbolList[index], index) == false) {
          return false;
        }
      }
    }
    return true;
  }

  bool isSymbolValidAtIndex(Symbol symbol, int index) {
    List<int> otherSymbolIndexInRegions = [];
    otherSymbolIndexInRegions.addAll(Grid.getIndexListOfBoxInSameRow(index));
    otherSymbolIndexInRegions.addAll(Grid.getIndexListOfBoxInSameColumn(index));
    otherSymbolIndexInRegions.addAll(Grid.getIndexListOfBoxInSameBlock(index));
    for (int symbolIndex in otherSymbolIndexInRegions) {
      if (_symbolList[symbolIndex] == symbol) {
        return false;
      }
    }
    return true;
  }
}
