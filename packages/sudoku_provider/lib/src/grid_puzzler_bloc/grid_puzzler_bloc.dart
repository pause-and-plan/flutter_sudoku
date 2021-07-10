import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../grid_generator_bloc/grid_generator_bloc.dart';
import '../helpers/grid.dart';
import '../helpers/grid_debugger.dart';
import '../helpers/grid_resolver.dart';
import '../models/box_model.dart';
import '../models/symbol_model.dart';

part 'grid_puzzler_event.dart';
part 'grid_puzzler_state.dart';

class GridPuzzlerBloc extends Bloc<GridPuzzlerEvent, GridPuzzlerState> {
  late List<BoxPuzzled> originalGrid;
  late List<BoxPuzzled> puzzleGrid;
  late GridLevel _level;
  int _index = 0;
  int _progression = 0;
  late List<int> _puzzleList = List.generate(Grid.length, (index) => index)
    ..shuffle();

  GridPuzzlerBloc() : super(GridPuzzlerInitial());

  @override
  Stream<GridPuzzlerState> mapEventToState(
    GridPuzzlerEvent event,
  ) async* {
    if (event is GridPuzzlerStartEvent) {
      yield* _startEventToState(event);
    }
  }

  Stream<GridPuzzlerState> _startEventToState(
      GridPuzzlerStartEvent event) async* {
    originalGrid = GridPuzzlerBloc.disableGrid(event.boxList);
    puzzleGrid = GridPuzzlerBloc.disableGrid(event.boxList);
    _level = event.level;
    _adaptPuzzleListWithLevel();
    _progression = 0;
    yield* _puzzlify();
  }

  Stream<GridPuzzlerState> _puzzlify() async* {
    while (_puzzleList.isNotEmpty) {
      _progression = _puzzleList.length ~/ _levelToAmountOfTry();
      _index = _pickIndexInList();
      _tryToPuzzlifyBox();
      yield GridPuzzlerRunning(
        boxList: originalGrid,
        progression: _progression,
      );
    }
    yield GridPuzzlerComplete(boxList: originalGrid);
  }

  _tryToPuzzlifyBox() {
    try {
      // GridDebugger debugger = GridDebugger.clean(originalGrid);
      // debugger.debug();
      // print('\n');
      originalGrid[_index].editable = true;
      _puzzlifyBox();
    } catch (error) {
      // print(error);
      originalGrid[_index].editable = false;
    }
  }

  _puzzlifyBox() {
    _updatePuzzleGridFromOriginalGrid();
    GridResolver resolver = GridResolver(boxList: puzzleGrid);
    resolver.resolve();
  }

  _updatePuzzleGridFromOriginalGrid() {
    for (int i = 0; i < Grid.length; i++) {
      if (originalGrid[i].editable) {
        puzzleGrid[i] = BoxPuzzled.ordered();
      } else {
        puzzleGrid[i] = BoxPuzzled.disable(symbol: originalGrid[i].symbol);
      }
    }
  }

  int _pickIndexInList() {
    int index = _puzzleList[0];
    _puzzleList.removeAt(0);
    return index;
  }

  _adaptPuzzleListWithLevel() {
    int amountOfTry = _levelToAmountOfTry();
    int amountOfRemoved = Grid.length - amountOfTry;
    _puzzleList.removeRange(0, amountOfRemoved);
  }

  int _levelToAmountOfTry() {
    switch (_level) {
      case GridLevel.beginner:
        return Grid.length - 50;
      case GridLevel.easy:
        return Grid.length - 40;
      case GridLevel.medium:
        return Grid.length - 30;
      case GridLevel.advanced:
        return Grid.length - 20;
      case GridLevel.expert:
        return Grid.length - 0;
    }
  }

  static List<BoxPuzzled> disableGrid(List<Box> boxList) {
    return boxList.map((e) => BoxPuzzled.disable(symbol: e.symbol)).toList();
  }
}
