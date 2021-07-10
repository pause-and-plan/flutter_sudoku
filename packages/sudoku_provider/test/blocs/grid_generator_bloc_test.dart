import 'package:sudoku_provider/src/grid_generator_bloc/grid_generator_bloc.dart';
import 'package:sudoku_provider/src/helpers/grid.dart';
import 'package:sudoku_provider/src/helpers/grid_debugger.dart';
import 'package:sudoku_provider/src/helpers/grid_validator.dart';
import 'package:sudoku_provider/sudoku_provider.dart';
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
      for (BoxPuzzled box in gridBloc.state.boxList) {
        expect(box.symbol, Symbol.none());
        expect(box.hasSymbol, false);
        expect(box.availableSymbols.length, 9);
      }
    });

    blocTest(
      'state should be complete',
      build: () => gridBloc,
      act: (GridGeneratorBloc bloc) => bloc.add(GridGeneratorStartEvent()),
      verify: (GridGeneratorBloc bloc) {
        expect(bloc.state is GridGeneratorComplete, true);
      },
    );
    blocTest(
      'complete state grid should be valid',
      build: () => gridBloc,
      act: (GridGeneratorBloc bloc) => bloc.add(GridGeneratorStartEvent()),
      verify: (GridGeneratorBloc bloc) {
        List<BoxPuzzled> boxList = bloc.state.boxList;
        for (BoxPuzzled box in bloc.state.boxList) {
          expect(box.symbol != Symbol.none(), true);
          expect(box.hasSymbol, true);
          expect(box.availableSymbols.length < 9, true);
        }
        GridValidator validator = GridValidator.fromBoxList(boxList: boxList);
        expect(validator.isValid(), true);
      },
    );

    blocTest(
      'state visual debug',
      build: () => gridBloc,
      act: (GridGeneratorBloc bloc) => bloc.add(GridGeneratorStartEvent()),
      verify: (GridGeneratorBloc bloc) {
        List<BoxPuzzled> boxList = bloc.state.boxList;
        GridDebugger debugger = GridDebugger.boxList(boxList);
        debugger.debug();
      },
    );

    tearDown(() {
      gridBloc.close();
    });
  });
}
