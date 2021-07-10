import 'package:sudoku_provider/src/models/box_model.dart';
import 'package:sudoku_provider/src/models/symbol_model.dart';
import 'package:test/test.dart';

void main() {
  group('box puzzle class', () {
    test('property availableSymbols list should be mutable', () {
      BoxPuzzled orderedBox = BoxPuzzled.ordered();
      BoxPuzzled unorderedBox = BoxPuzzled.unordered();

      expect(orderedBox.availableSymbols.length, 9);
      expect(unorderedBox.availableSymbols.length, 9);
      orderedBox.availableSymbols.removeAt(0);
      unorderedBox.availableSymbols.removeAt(0);
      expect(orderedBox.availableSymbols.length, 8);
      expect(unorderedBox.availableSymbols.length, 8);
    });
    test('property symbol should be mutable', () {
      BoxPuzzled box = BoxPuzzled.ordered();

      expect(box.symbol, Symbol.none());
      expect(box.hasSymbol, false);
      box.symbol = Symbol.s1();
      expect(box.symbol, Symbol.s1());
      expect(box.hasSymbol, true);
    });
  });
}
