import 'package:sudoku_provider/src/grid_generator_bloc/grid_generator_bloc.dart';
import 'package:sudoku_provider/src/grid_puzzler_bloc/grid_puzzler_bloc.dart';
import 'package:sudoku_provider/src/helpers/grid_debugger.dart';
import 'package:sudoku_provider/src/helpers/grid_resolver.dart';
import 'package:sudoku_provider/src/helpers/grid_validator.dart';
import 'package:sudoku_provider/src/helpers/grid.dart';
import 'package:sudoku_provider/src/models/box_model.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  group('GridPuzzlerBloc', () {
    late GridGeneratorBloc generator;
    late GridPuzzlerBloc puzzler;
    final GridLevel level = GridLevel.beginner;

    setUp(() {
      generator = GridGeneratorBloc();
      puzzler = GridPuzzlerBloc();
      generator.stream.listen((GridGeneratorState state) {
        if (state is GridGeneratorComplete) {
          List<BoxPuzzled> boxList = state.boxList.map((box) {
            return BoxPuzzled.disable(symbol: box.symbol);
          }).toList();
          puzzler.add(GridPuzzlerStartEvent(boxList: boxList, level: level));
        }
      });
      generator.add(GridGeneratorStartEvent());
    });

    blocTest(
      'complete state should be complete',
      build: () => puzzler,
      verify: (GridPuzzlerBloc bloc) {
        expect(bloc.state is GridPuzzlerComplete, true);
      },
    );
    blocTest(
      'originalGrid should be filled',
      build: () => puzzler,
      verify: (GridPuzzlerBloc bloc) {
        List<BoxPuzzled> boxList = bloc.state.boxList;
        GridValidator validator = GridValidator.fromBoxList(boxList: boxList);
        expect(validator.isValid(), true);
      },
    );

    blocTest(
      'grid should have 1 solution',
      build: () => puzzler,
      verify: (GridPuzzlerBloc bloc) {
        List<BoxPuzzled> originalGrid = bloc.state.boxList;
        List<BoxPuzzled> puzzleGrid = originalGrid.map((BoxPuzzled box) {
          if (box.editable) {
            return BoxPuzzled.ordered();
          } else {
            return BoxPuzzled.disable(symbol: box.symbol);
          }
        }).toList();
        GridResolver resolver = GridResolver(boxList: puzzleGrid);
        resolver.resolve();
      },
    );

    blocTest(
      'visual check should be ok',
      build: () => puzzler,
      verify: (GridPuzzlerBloc bloc) {
        GridDebugger debugger1 = GridDebugger.boxList(generator.state.boxList);
        debugger1.debug();
        print('\n');
        GridDebugger debugger2 = GridDebugger.clean(bloc.state.boxList);
        debugger2.debug();
      },
    );

    tearDown(() {
      generator.close();
      puzzler.close();
    });
  });
}
