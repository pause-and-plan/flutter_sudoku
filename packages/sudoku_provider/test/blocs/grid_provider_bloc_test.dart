import 'package:sudoku_provider/src/grid_provider_bloc/grid_provider_bloc.dart';
import 'package:sudoku_provider/src/helpers/grid_debugger.dart';
import 'package:sudoku_provider/src/helpers/grid_validator.dart';
import 'package:sudoku_provider/src/helpers/grid.dart';
import 'package:sudoku_provider/src/models/box_model.dart';
import 'package:sudoku_provider/src/models/symbol_model.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('GridProviderBloc', () {
    late GridProviderBloc provider;

    setUp(() {
      provider = GridProviderBloc();
    });

    blocTest(
      'initial state visual check should be ok',
      build: () => provider,
      verify: (GridProviderBloc bloc) {
        List<BoxPuzzled> boxList = bloc.state.boxList;
        GridDebugger debugger = GridDebugger.boxList(boxList);
        debugger.debug();
      },
    );
    blocTest(
      'initial state should contain empty grid',
      build: () => provider,
      verify: (GridProviderBloc bloc) {
        List<BoxPuzzled> boxList = bloc.state.boxList;
        for (BoxPuzzled box in boxList) {
          expect(box.editable, true);
          expect(box.symbol, Symbol.none());
          expect(box.hasSymbol, false);
          expect(box.availableSymbols.length, 9);
        }
      },
    );

    blocTest(
      'complete state should be complete',
      build: () => provider,
      act: (GridProviderBloc bloc) =>
          bloc.add(GridProviderStartEvent(level: GridLevel.beginner)),
      verify: (GridProviderBloc bloc) {
        expect(bloc.state is GridProviderComplete, true);
        expect(
          (bloc.state as GridProviderComplete).step,
          GridProviderStep.puzzle,
        );
      },
    );
    blocTest(
      'complete state should contain valid grid with 1 solution',
      build: () => provider,
      act: (GridProviderBloc bloc) =>
          bloc.add(GridProviderStartEvent(level: GridLevel.beginner)),
      verify: (GridProviderBloc bloc) {
        List<BoxPuzzled> boxList = bloc.state.boxList;
        GridValidator validator = GridValidator.fromBoxList(boxList: boxList);
        expect(validator.isValid(), true);
      },
    );

    blocTest(
      'complete state level should be beginner',
      build: () => provider,
      act: (GridProviderBloc bloc) =>
          bloc.add(GridProviderStartEvent(level: GridLevel.beginner)),
      verify: (GridProviderBloc bloc) {
        expect(bloc.level, GridLevel.beginner);
      },
    );

    blocTest(
      'complete state visual check should be ok',
      build: () => provider,
      act: (GridProviderBloc bloc) =>
          bloc.add(GridProviderStartEvent(level: GridLevel.beginner)),
      verify: (GridProviderBloc bloc) {
        List<BoxPuzzled> boxList = bloc.state.boxList;
        GridDebugger debugger = GridDebugger.clean(boxList);
        debugger.debug();
      },
    );

    tearDown(() {
      provider.close();
    });
  });
}
