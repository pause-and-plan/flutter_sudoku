import 'package:sudoku_provider/src/models/box_model.dart';
import 'package:sudoku_provider/src/models/symbol_model.dart';
import 'package:test/test.dart';

void main() {
  group('box puzzle class', () {
    test('property availableSymbols list should be immutable', () {
      BoxPuzzled orderedBox = BoxPuzzled.ordered();
      BoxPuzzled unorderedBox = BoxPuzzled.unordered();

      expect(orderedBox.availableSymbols.length, 9);
      expect(unorderedBox.availableSymbols.length, 9);
      orderedBox = orderedBox.copyWithoutAvailableSymbol(Symbol.s1());
      unorderedBox = unorderedBox.copyWithoutAvailableSymbol(Symbol.s1());
      expect(orderedBox.availableSymbols.length, 8);
      expect(unorderedBox.availableSymbols.length, 8);
    });
    test('property symbol should be immutable', () {
      BoxPuzzled box = BoxPuzzled.ordered();

      expect(box.symbol, Symbol.none());
      expect(box.hasSymbol, false);
      box = box.copyWith(symbol: Symbol.s1());
      expect(box.symbol, Symbol.s1());
      expect(box.hasSymbol, true);
    });
  });
}
