import 'package:sudoku_provider/src/models/symbol_model.dart';
import 'package:test/test.dart';

void main() {
  group('symbol class', () {
    test('default instance should have value', () {
      final Symbol symbol = Symbol(value: Symbols.s1);
      expect(symbol.value, Symbols.s1);
      expect(Symbol.orderedList().contains(symbol), true);
      expect(symbol.hasValue, true);
    });

    test('none instance should not have value', () {
      final Symbol symbol = Symbol.none();
      expect(symbol.value, Symbols.none);
      expect(Symbol.orderedList().contains(symbol), false);
      expect(symbol.hasValue, false);
    });

    test('orderedList length should be 9', () {
      expect(Symbol.orderedList().length, 9);
    });

    test('unorderedList should be unordered [in 99.99% case]', () {
      List<Symbol> symbolListOrdered = Symbol.orderedList();
      int tryAmount = 100;
      bool hasDifference = false;

      while (hasDifference == false && tryAmount > 0) {
        List<Symbol> symbolListUnordered = Symbol.unorderedList();
        for (int i = 0; i < Symbol.orderedList().length; i++) {
          if (symbolListOrdered[i] != symbolListUnordered[i]) {
            hasDifference = true;
          }
        }
        tryAmount--;
      }
      expect(hasDifference, true);
    });
  });
}
