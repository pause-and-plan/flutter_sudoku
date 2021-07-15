import 'package:equatable/equatable.dart';
import 'package:sudoku_provider/sudoku_provider.dart';

class Box extends Equatable {
  final Symbol soluce;
  final Symbol symbol;
  final List<Symbol> annotations;
  final bool isPuzzle;
  final bool isFocus;
  final bool isHint;
  bool get hasError => symbol.hasValue && soluce != symbol;
  bool get disable => !isPuzzle;

  const Box({
    required this.soluce,
    required this.symbol,
    required this.annotations,
    required this.isPuzzle,
    this.isFocus = false,
    this.isHint = false,
  });

  const Box.disable({
    required Symbol soluce,
  }) : this(
          soluce: soluce,
          symbol: soluce,
          annotations: const [],
          isPuzzle: false,
        );

  const Box.puzzle({
    required Symbol soluce,
    Symbol symbol = const Symbol.none(),
    List<Symbol> annotations = const [],
  }) : this(
          soluce: soluce,
          symbol: symbol,
          annotations: annotations,
          isPuzzle: true,
        );

  Box reset() {
    if (isPuzzle) {
      return Box.puzzle(soluce: this.soluce);
    } else {
      return Box.disable(soluce: this.soluce);
    }
  }

  List<Symbol> toggleAnnotation(Symbol symbol) {
    List<Symbol> nextAnnotations = [...annotations];
    if (annotations.contains(symbol)) {
      nextAnnotations.remove(symbol);
    } else {
      nextAnnotations.add(symbol);
    }
    return nextAnnotations;
  }

  Box copyWith({
    Symbol? soluce,
    Symbol? symbol,
    List<Symbol>? annotations,
    bool? isPuzzle,
    bool? isFocus,
    bool? isHint,
  }) {
    return Box(
      soluce: soluce ?? this.soluce,
      symbol: symbol ?? this.symbol,
      annotations: annotations ?? this.annotations,
      isPuzzle: isPuzzle ?? this.isPuzzle,
      isFocus: isFocus ?? this.isFocus,
      isHint: isHint ?? this.isHint,
    );
  }

  @override
  List<Object> get props => [
        soluce,
        symbol,
        annotations,
        isPuzzle,
        isFocus,
      ];
}
