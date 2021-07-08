import 'package:equatable/equatable.dart';
import 'package:sudoku_provider/models/symbol_model.dart';

class BoxGenerator extends Equatable {
  Symbol symbol;
  List<Symbol> availableSymbols;
  bool get hasSymbol => symbol.hasValue;

  BoxGenerator({required this.symbol, required this.availableSymbols});
  BoxGenerator.ordered()
      : this(symbol: Symbol.none(), availableSymbols: Symbol.orderedList());
  BoxGenerator.unordered()
      : this(symbol: Symbol.none(), availableSymbols: Symbol.unorderedList());

  @override
  List<Object> get props => [symbol, availableSymbols];
}
