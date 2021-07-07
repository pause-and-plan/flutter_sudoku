class Box {
  final List<int> availableSymbols;
  final int symbol;
  final bool isPuzzle;

  const Box({
    required this.availableSymbols,
    this.symbol = Symbols.none,
    this.isPuzzle = false,
  });

  Box.initial({int? symbol, bool? isPuzzle})
      : this(
          availableSymbols: Symbols.list(),
          symbol: symbol ?? Symbols.none,
          isPuzzle: isPuzzle ?? false,
        );
  Box.shuffle() : this(availableSymbols: Symbols.list()..shuffle());

  Box copyWith({availableSymbols, symbol, isPuzzle}) {
    return Box(
      availableSymbols: availableSymbols ?? [...this.availableSymbols],
      symbol: symbol ?? this.symbol,
      isPuzzle: isPuzzle ?? this.isPuzzle,
    );
  }

  bool get isEmpty => symbol == Symbols.none;
  bool get isFilled => symbol != Symbols.none;

  @override
  String toString() {
    int length = availableSymbols.length;
    return 'symbol $symbol\navailableSymbolsLength $length\nisPuzzle $isPuzzle\n';
  }
}

class Symbols {
  static const int none = 0;
  static const int s1 = 1;
  static const int s2 = 2;
  static const int s3 = 3;
  static const int s4 = 4;
  static const int s5 = 5;
  static const int s6 = 6;
  static const int s7 = 7;
  static const int s8 = 8;
  static const int s9 = 9;

  static List<int> list() => [s1, s2, s3, s4, s5, s6, s7, s8, s9];
}
