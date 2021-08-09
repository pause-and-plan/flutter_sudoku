import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
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
  List<Box> _boxList = GridState.initialBoxList();
  bool _annotation = false;
  bool _soluce = false;
  int _index = 0;
  Box get _currBox => _boxList[_index];
  set _currBox(Box box) {
    List<Box> next = [..._boxList];
    next[_index] = box;
    _boxList = next;
  }

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
    } else if (timerBloc.state is TimerRunning) {
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
    List<Box> nextList = _boxList.map((Box box) {
      return box.copyWith(symbol: box.soluce);
    }).toList();
    _boxList = nextList;
    // yield GridComplete(boxList: _boxList, annotation: _annotation);
    yield state.copyWith(boxList: _boxList);
  }

  Stream<GridState> _undoEventToState(GridUndoEvent event) async* {
    if (_history.isNotEmpty) {
      _boxList = _history.last.boxList;
      _index = _history.last.index;
      _history.removeLast();
      yield state.copyWith(boxList: _boxList);
    }
  }

  Stream<GridState> _pressAnnotationEventToState(
      GridPressAnnotationEvent event) async* {
    _annotation = !_annotation;
    yield state.copyWith(annotation: _annotation);
  }

  Stream<GridState> _pressCheckEventToState(GridPressCheckEvent event) async* {
    _soluce = !_soluce;
    yield state.copyWith(soluce: _soluce);
  }

  Stream<GridState> _resetEventToState(GridResetEvent event) async* {
    _boxList = _boxList.map((Box box) => box.reset()).toList();
    yield state.copyWith(boxList: _boxList);
    _history = [];
  }

  Stream<GridState> _pressSymbolEventToState(
      GridPressSymbolEvent event) async* {
    if (_currBox.isFocus) {
      _history.add(GridVersion(boxList: _boxList, index: _index));
      if (_annotation) {
        List<Symbol> nextAnnotations = _currBox.toggleAnnotation(event.symbol);
        _currBox = _currBox.copyWith(
          symbol: Symbol.none(),
          annotations: nextAnnotations,
        );
      } else {
        _currBox = _currBox.copyWith(symbol: event.symbol, annotations: []);
      }
      if (_shouldConsiderGridAsComplete()) {
        yield state.copyWith(status: GridStatus.complete);
        timerBloc.add(TimerStopEvent());
      } else {
        yield state.copyWith(boxList: _boxList);
      }
    }
  }

  Stream<GridState> _pressEraseEventToState(GridPressEraseEvent event) async* {
    if (_currBox.isFocus) {
      _history.add(GridVersion(boxList: _boxList, index: _index));
      _currBox = _currBox.reset().copyWith(isFocus: true);
      yield state.copyWith(boxList: _boxList);
    }
  }

  Stream<GridState> _buildEventToState(GridBuildingEvent event) async* {
    if (event.state is GridRepoInitial) {
      yield GridState.initial(event.state.boxList);
    } else if (event.state is GridRepoRunning) {
      yield GridState.inCreation(event.state.boxList);
    } else if (event.state is GridRepoComplete) {
      _boxList = event.state.boxList;
      _history = [];
      timerBloc.add(TimerPlayEvent());
      yield GridState.inEdition(
        boxList: _boxList,
        annotation: _annotation,
        soluce: _soluce,
      );
    }
  }

  Stream<GridState> _pressBoxEventToState(GridPressBoxEvent event) async* {
    if (_boxList[event.index].isPuzzle) {
      if (event.index != _index) {
        _currBox = _currBox.copyWith(isFocus: false);
        _index = event.index;
        _currBox = _currBox.copyWith(isFocus: true);
      } else {
        _currBox = _currBox.copyWith(isFocus: !_currBox.isFocus);
      }
      yield state.copyWith(boxList: _boxList);
    }
  }

  bool _shouldConsiderGridAsComplete() {
    if (_boxList.isEmpty) return false;
    for (Box box in _boxList) {
      if (box.symbol.hasValue == false) return false;
      if (box.hasError) return false;
    }
    return true;
  }

  @override
  GridState fromJson(Map<String, dynamic> json) {
    // GridState.fromJson(json);
    return GridState.initial(GridState.initialBoxList());
  }

  @override
  Map<String, dynamic> toJson(GridState state) => state.toJson();
  // Map<String, dynamic> toJson(GridState state) => {};
}
