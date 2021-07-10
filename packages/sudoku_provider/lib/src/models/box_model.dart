import 'package:equatable/equatable.dart';
import '../models/symbol_model.dart';

abstract class Box extends Equatable {
  Symbol symbol;
  bool get hasSymbol => symbol.hasValue;

  Box({required this.symbol});

  @override
  List<Object> get props => [symbol];
}

enum PuzzleStatus { locked, unlocked }

class BoxPuzzled extends Box {
  List<Symbol> availableSymbols;
  bool editable = true;
  bool get disable => !editable;

  BoxPuzzled({
    required Symbol symbol,
    required this.availableSymbols,
    this.editable = true,
  }) : super(symbol: symbol);

  BoxPuzzled.disable({required Symbol symbol})
      : this(
          symbol: symbol,
          availableSymbols: Symbol.orderedList(),
          editable: false,
        );
  BoxPuzzled.ordered()
      : this(symbol: Symbol.none(), availableSymbols: Symbol.orderedList());
  BoxPuzzled.unordered()
      : this(symbol: Symbol.none(), availableSymbols: Symbol.unorderedList());

  Symbol pickAvailableSymbol() {
    Symbol symbol = availableSymbols[0];
    availableSymbols.removeAt(0);
    return symbol;
  }

  @override
  List<Object> get props => [symbol, availableSymbols];
}
