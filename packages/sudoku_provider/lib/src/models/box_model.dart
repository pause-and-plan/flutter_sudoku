import 'package:equatable/equatable.dart';
import '../models/symbol_model.dart';

class BoxPuzzled extends Equatable {
  final Symbol symbol;
  final List<Symbol> availableSymbols;
  final bool editable;
  bool get disable => !editable;
  bool get hasSymbol => symbol.hasValue;

  const BoxPuzzled({
    required this.symbol,
    required this.availableSymbols,
    this.editable = true,
  });

  const BoxPuzzled.disable({required Symbol symbol})
      : this(symbol: symbol, availableSymbols: const [], editable: false);
  const BoxPuzzled.editable({required List<Symbol> availableSymbols})
      : this(symbol: const Symbol.none(), availableSymbols: availableSymbols);

  // const BoxPuzzled.ordered()
  //     : this(symbol: const Symbol.none(), availableSymbols: Symbol.list);
  // const BoxPuzzled.unordered({required availableSymbols})
  //     : this(symbol: const Symbol.none(), availableSymbols: availableSymbols);

  Symbol getFirstAvailableSymbol() {
    return availableSymbols[0];
  }

  BoxPuzzled copyWithoutAvailableSymbol(Symbol symbol) {
    List<Symbol> nextAvailableSymbol = [...availableSymbols]..remove(symbol);
    return copyWith(availableSymbols: nextAvailableSymbol);
  }

  BoxPuzzled copyWithSymbol(Symbol symbol) {
    List<Symbol> nextAvailableSymbol = [...availableSymbols]..remove(symbol);
    return copyWith(symbol: symbol, availableSymbols: nextAvailableSymbol);
  }

  BoxPuzzled copyWith({
    Symbol? symbol,
    List<Symbol>? availableSymbols,
    bool? editable,
  }) {
    return BoxPuzzled(
      symbol: symbol ?? this.symbol,
      availableSymbols: availableSymbols ?? this.availableSymbols,
      editable: editable ?? this.editable,
    );
  }

  @override
  List<Object> get props => [symbol, availableSymbols, editable];

  static BoxPuzzled unordered() {
    return BoxPuzzled.editable(availableSymbols: Symbol.unorderedList());
  }

  static BoxPuzzled ordered() {
    return BoxPuzzled.editable(availableSymbols: Symbol.orderedList());
  }
}
