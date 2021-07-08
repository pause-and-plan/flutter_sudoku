import 'package:sudoku_provider/models/box_generator_model.dart';
import 'package:sudoku_provider/models/symbol_model.dart';
import 'package:test/test.dart';

void main() {
  group('class box generator', () {
    test('property availableSymbols list should be mutable', () {
      BoxGenerator orderedBox = BoxGenerator.ordered();
      BoxGenerator unorderedBox = BoxGenerator.unordered();

      expect(orderedBox.availableSymbols.length, 9);
      expect(unorderedBox.availableSymbols.length, 9);
      orderedBox.availableSymbols.removeAt(0);
      unorderedBox.availableSymbols.removeAt(0);
      expect(orderedBox.availableSymbols.length, 8);
      expect(unorderedBox.availableSymbols.length, 8);
    });
    test('property symbol should be mutable', () {
      BoxGenerator box = BoxGenerator.ordered();

      expect(box.symbol, Symbol.none());
      expect(box.hasSymbol, false);
      box.symbol = Symbol.s1();
      expect(box.symbol, Symbol.s1());
      expect(box.hasSymbol, true);
    });
  });
}
