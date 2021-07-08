import 'package:sudoku_provider/grid_generator_bloc/grid_generator_bloc.dart';
import 'package:sudoku_provider/models/box_generator_model.dart';
import 'package:sudoku_provider/models/grid_model.dart';
import 'package:sudoku_provider/models/symbol_model.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('GridGeneratorBloc', () {
    late GridGeneratorBloc gridBloc;

    setUp(() {
      gridBloc = GridGeneratorBloc();
    });

    test('initial state should contain list of 81 box ', () {
      expect(gridBloc.state.boxList.length, Grid.length);
    });

    test('initial state boxList should be filled with initial Box', () {
      for (BoxGenerator box in gridBloc.state.boxList) {
        expect(box.symbol, Symbol.none());
        expect(box.hasSymbol, false);
        expect(box.availableSymbols.length, 9);
      }
    });

    blocTest(
      'running state boxList should contain box with value',
      build: () => gridBloc,
      act: (GridGeneratorBloc bloc) => bloc.add(GenerateGridEvent()),
      // expect: () => [],
      verify: (GridGeneratorBloc bloc) {
        BoxGenerator box = bloc.state.boxList[0];
        expect(box.symbol, Symbol.none());
        expect(box.hasSymbol, true);
        expect(box.availableSymbols.length < 9, true);
      },
    );
  });
}

/// Problemes
/// 
/// Comment tester autre chose que l'etat ?
/// 
/// Comment rendre mon generateur de grile de sudoku previsible avec une seed ?
/// 
/// 