import 'package:equatable/equatable.dart';

class Symbol extends Equatable {
  final Symbols value;

  const Symbol({required this.value});
  const Symbol.none() : this(value: Symbols.none);
  const Symbol.s1() : this(value: Symbols.s1);
  const Symbol.s2() : this(value: Symbols.s2);
  const Symbol.s3() : this(value: Symbols.s3);
  const Symbol.s4() : this(value: Symbols.s4);
  const Symbol.s5() : this(value: Symbols.s5);
  const Symbol.s6() : this(value: Symbols.s6);
  const Symbol.s7() : this(value: Symbols.s7);
  const Symbol.s8() : this(value: Symbols.s8);
  const Symbol.s9() : this(value: Symbols.s9);

  @override
  List<Object> get props => [value];

  @override
  String toString() {
    switch (value) {
      case Symbols.none:
        return ' ';
      case Symbols.s1:
        return '1';
      case Symbols.s2:
        return '2';
      case Symbols.s3:
        return '3';
      case Symbols.s4:
        return '4';
      case Symbols.s5:
        return '5';
      case Symbols.s6:
        return '6';
      case Symbols.s7:
        return '7';
      case Symbols.s8:
        return '8';
      case Symbols.s9:
        return '9';
    }
  }

  bool get hasValue => value != Symbols.none;

  static const List<Symbol> _list = [
    Symbol(value: Symbols.s1),
    Symbol(value: Symbols.s2),
    Symbol(value: Symbols.s3),
    Symbol(value: Symbols.s4),
    Symbol(value: Symbols.s5),
    Symbol(value: Symbols.s6),
    Symbol(value: Symbols.s7),
    Symbol(value: Symbols.s8),
    Symbol(value: Symbols.s9),
  ];
  static List<Symbol> orderedList() => [..._list];
  static List<Symbol> unorderedList() => orderedList()..shuffle();
}

enum Symbols { none, s1, s2, s3, s4, s5, s6, s7, s8, s9 }
