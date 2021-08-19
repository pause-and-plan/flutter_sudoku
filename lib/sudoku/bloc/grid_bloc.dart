import 'dart:async';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sudoku/sudoku/bloc/timer_bloc.dart';
import 'package:sudoku/sudoku/model/box_model.dart';
import 'package:sudoku/sudoku/model/grid_version_model.dart';
import 'package:sudoku/sudoku/repo/grid_repo/grid_repo_bloc.dart';
import 'package:sudoku_provider/sudoku_provider.dart';

part 'grid_event.dart';
part 'grid_state.dart';

class GridBloc extends HydratedBloc<GridEvent, GridState> {
  final GridRepoBloc repo = GridRepoBloc();
  final TimerBloc timerBloc;
  List<GridVersion> _history = [];

  GridBloc({required this.timerBloc})
      : super(GridState.initial(GridState.initialBoxList())) {
    repo.stream.listen((GridRepoState state) {
      add(GridBuildingEvent(state));
    });
  }

  @override
  Stream<GridState> mapEventToState(
    GridEvent event,
  ) async* {
    if (event is GridBuildEvent) {
      repo.add(GridRepoStartEvent(level: event.level));
      timerBloc.add(TimerResetEvent());
    } else if (event is GridBuildingEvent) {
      yield* _buildEventToState(event);
    } else if (timerBloc.state.isRunning) {
      if (event is GridPressBoxEvent) {
        yield* _pressBoxEventToState(event);
      } else if (event is GridPressSymbolEvent) {
        yield* _pressSymbolEventToState(event);
      } else if (event is GridPressEraseEvent) {
        yield* _pressEraseEventToState(event);
      } else if (event is GridResetEvent) {
        yield* _resetEventToState(event);
      } else if (event is GridPressCheckEvent) {
        yield* _pressCheckEventToState(event);
      } else if (event is GridPressAnnotationEvent) {
        yield* _pressAnnotationEventToState(event);
      } else if (event is GridUndoEvent) {
        yield* _undoEventToState(event);
      } else if (event is TestGridWinEvent) {
        yield* _winTestEventToState();
      }
    }
  }

  Stream<GridState> _winTestEventToState() async* {
    List<Box> nextList = state.boxList.map((Box box) {
      return box.copyWith(symbol: box.soluce);
    }).toList();
    // yield GridComplete(boxList: _boxList, annotation: _annotation);
    yield state.copyWith(boxList: nextList);
  }

  Stream<GridState> _undoEventToState(GridUndoEvent event) async* {
    if (_history.isNotEmpty) {
      List<Box> nextList = _history.last.boxList;
      int nextIndex = _history.last.index;
      _history.removeLast();
      yield state.copyWith(boxList: nextList, currBoxIndex: nextIndex);
    }
  }

  Stream<GridState> _pressAnnotationEventToState(
      GridPressAnnotationEvent event) async* {
    yield state.copyWith(annotation: !state.annotation);
  }

  Stream<GridState> _pressCheckEventToState(GridPressCheckEvent event) async* {
    yield state.copyWith(soluce: !state.soluce);
  }

  Stream<GridState> _resetEventToState(GridResetEvent event) async* {
    List<Box> nextList = state.boxList.map((Box box) => box.reset()).toList();
    yield state.copyWith(boxList: nextList);
    _history = [];
  }

  saveInHistory() {
    _history.add(GridVersion(
      boxList: state.boxList,
      index: state.currBoxIndex,
    ));
  }

  Stream<GridState> _pressAnnotationSymbolEventToState(
      GridPressSymbolEvent event) async* {
    List<Symbol> nextAnnotations = state.currBox.toggleAnnotation(event.symbol);
    Box nextBox = state.currBox.copyWith(
      symbol: Symbol.none(),
      annotations: nextAnnotations,
    );
    List<Box> nextList = state.replaceBox(nextBox);
    yield state.copyWith(boxList: nextList);
  }

  Stream<GridState> _pressBoxSymbolEventToState(
      GridPressSymbolEvent event) async* {
    Box nextBox = state.currBox.copyWith(symbol: event.symbol, annotations: []);
    List<Box> nextList = state.replaceBox(nextBox);

    if (_shouldConsiderGridAsComplete(nextList)) {
      yield state.copyWith(status: GridStatus.complete, boxList: nextList);
      timerBloc.add(TimerStopEvent());
    } else {
      yield state.copyWith(boxList: nextList);
    }
  }

  bool _shouldConsiderGridAsComplete(List<Box> boxList) {
    if (boxList.isEmpty) return false;
    for (Box box in boxList) {
      if (box.symbol.hasValue == false) return false;
      if (box.hasError) return false;
    }
    return true;
  }

  Stream<GridState> _pressSymbolEventToState(
      GridPressSymbolEvent event) async* {
    if (state.currBox.isFocus) {
      saveInHistory();
      if (state.annotation) {
        yield* _pressAnnotationSymbolEventToState(event);
      } else {
        yield* _pressBoxSymbolEventToState(event);
      }
    }
  }

  Stream<GridState> _pressEraseEventToState(GridPressEraseEvent event) async* {
    if (state.currBox.isFocus) {
      saveInHistory();
      Box nextBox = state.currBox.reset().copyWith(isFocus: true);
      List<Box> nextList = state.replaceBox(nextBox);
      yield state.copyWith(boxList: nextList);
    }
  }

  Stream<GridState> _buildEventToState(GridBuildingEvent event) async* {
    if (event.state is GridRepoInitial) {
      yield GridState.initial(event.state.boxList);
    } else if (event.state is GridRepoRunning) {
      yield GridState.inCreation(event.state.boxList);
    } else if (event.state is GridRepoComplete) {
      List<Box> nextList = event.state.boxList;
      _history = [];
      timerBloc.add(TimerPlayEvent());
      yield GridState.inEdition(
          boxList: nextList,
          annotation: state.annotation,
          soluce: state.soluce,
          currBoxIndex: state.currBoxIndex);
    }
  }

  Stream<GridState> _pressBoxEventToState(GridPressBoxEvent event) async* {
    if (state.boxList[event.index].isPuzzle) {
      List<Box> nextList = [...state.boxList];
      if (event.index != state.currBoxIndex) {
        int oldIndex = state.currBoxIndex;
        nextList[oldIndex] = nextList[oldIndex].copyWith(isFocus: false);
        nextList[event.index] = nextList[event.index].copyWith(isFocus: true);
      } else {
        nextList[event.index] = nextList[event.index].copyWith(isFocus: true);
        Box nextBox = state.currBox.copyWith(isFocus: !state.currBox.isFocus);
        nextList[event.index] = nextBox;
      }
      yield state.copyWith(boxList: nextList, currBoxIndex: event.index);
    }
  }

  @override
  GridState fromJson(Map<String, dynamic> json) {
    return GridState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(GridState state) => state.toJson();
}
