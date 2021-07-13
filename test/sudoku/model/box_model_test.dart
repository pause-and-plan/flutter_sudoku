import 'package:sudoku/sudoku/model/box_model.dart';
import 'package:sudoku_provider/sudoku_provider.dart';
import 'package:test/test.dart';

void main() {
  group('box model disable', () {
    test('should be disable', () {
      Box box = Box.disable(soluce: Symbol.s1());
      expect(box.disable, true);
      expect(box.isPuzzle, false);
    });
    test('should has value', () {
      Box box = Box.disable(soluce: Symbol.s1());
      expect(box.symbol.hasValue, true);
      expect(box.symbol, Symbol.s1());
    });
    test('should not have annotations', () {
      Box box = Box.disable(soluce: Symbol.s1());
      expect(box.annotations.length, 0);
    });
  });
  group('box model puzzle', () {
    test('should be a puzzle', () {
      Box box = Box.puzzle(soluce: Symbol.s1());
      expect(box.isPuzzle, true);
      expect(box.disable, false);
    });
    test('initial state should has no value', () {
      Box box = Box.puzzle(soluce: Symbol.s1());
      expect(box.symbol.hasValue, false);
      expect(box.symbol, Symbol.none());
    });
    test('initial state should not have annotations', () {
      Box box = Box.puzzle(soluce: Symbol.s1());
      expect(box.annotations.length, 0);
    });
  });
  group('box model copy', () {
    test('puzzle should have annotation', () {
      Box box = Box.puzzle(soluce: Symbol.s1());
      List<Symbol> nextAnnotation = box.toggleAnnotation(Symbol.s1());
      Box nextBox = box.copyWith(annotations: nextAnnotation);
      expect(box.annotations.isEmpty, true);
      expect(nextBox.annotations.isNotEmpty, true);
    });
    test('puzzle should have symbol', () {
      Box box = Box.puzzle(soluce: Symbol.s1());
      Box nextBox = box.copyWith(symbol: Symbol.s1());
      expect(box.symbol, Symbol.none());
      expect(box.symbol.hasValue, false);
      expect(nextBox.symbol, Symbol.s1());
      expect(nextBox.symbol.hasValue, true);
    });
    test('should be the same', () {
      Box box = Box.puzzle(soluce: Symbol.s1());
      Box nextBox = box.copyWith();
      expect(box, nextBox);
    });
  });
}
