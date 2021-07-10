import '../helpers/grid.dart';
import '../helpers/grid_validator.dart';
import '../models/box_model.dart';
import '../models/symbol_model.dart';

class GridResolver {
  List<BoxPuzzled> boxList;
  int _index = 0;
  int _direction = 1;
  int _soluceAmount = 0;
  BoxPuzzled get _currBox => boxList[_index];

  GridResolver({required this.boxList});
  GridResolver.fromEmptyGrid() : this(boxList: Grid.list);

  resolve() {
    _index = 0;
    while (0 <= _index) {
      if (_index == Grid.length) _handleIndexExceedGridLength();
      if (_currBox.editable) {
        _tryResolveCurrBox();
      }
      _index += _direction;
    }
    return boxList;
  }

  _tryResolveCurrBox() {
    try {
      _resolveCurrBox();
      _direction = 1;
    } catch (error) {
      boxList[_index] = BoxPuzzled.unordered();
      _direction = -1;
    }
  }

  void _resolveCurrBox() {
    while (_currBox.availableSymbols.isNotEmpty) {
      Symbol symbol = _currBox.pickAvailableSymbol();
      if (_canSetBoxSymbol(symbol)) {
        boxList[_index].symbol = symbol;
        return;
      }
    }
    throw ('No one available symbol can be set at this index');
  }

  bool _canSetBoxSymbol(Symbol symbol) {
    GridValidator validator = GridValidator.fromBoxList(boxList: boxList);
    return validator.isSymbolValidAtIndex(symbol, _index);
  }

  _handleIndexExceedGridLength() {
    _index = Grid.length - 1;
    _direction = -1;
    _soluceAmount += 1;
    if (_soluceAmount > 1) throw ('Invalid grid: soluce amount > 1');
  }
}
