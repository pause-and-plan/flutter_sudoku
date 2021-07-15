import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sudoku/sudoku/model/box_model.dart';
import 'package:sudoku/sudoku/repo/grid_repo/grid_repo_bloc.dart';
import 'package:sudoku_provider/sudoku_provider.dart';

part 'grid_event.dart';
part 'grid_state.dart';

class GridBloc extends Bloc<GridEvent, GridState> {
  final GridRepoBloc repo = GridRepoBloc();
  List<Box> _boxList = GridInitial.initialBoxList();
  bool _annotation = false;
  bool _soluce = false;
  int _index = 0;
  Box get _currBox => _boxList[_index];
  set _currBox(Box box) {
    List<Box> next = [..._boxList];
    next[_index] = box;
    _boxList = next;
  }

  GridBloc() : super(GridInitial(boxList: GridInitial.initialBoxList())) {
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
    } else if (event is GridBuildingEvent) {
      yield* _buildEventToState(event);
    } else if (event is GridPressBoxEvent) {
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
    }
  }

  Stream<GridState> _undoEventToState(GridUndoEvent event) async* {
    // yield (state as GridEditable).copyWith(annotation: _annotation);
  }

  Stream<GridState> _pressAnnotationEventToState(
      GridPressAnnotationEvent event) async* {
    _annotation = !_annotation;
    yield (state as GridEditable).copyWith(annotation: _annotation);
  }

  Stream<GridState> _pressCheckEventToState(GridPressCheckEvent event) async* {
    print('check');
    _soluce = !_soluce;
    yield (state as GridEditable).copyWith(soluce: _soluce);
  }

  Stream<GridState> _resetEventToState(GridResetEvent event) async* {
    _boxList = _boxList.map((Box box) => box.reset()).toList();
    yield (state as GridEditable).copyWith(boxList: _boxList);
  }

  Stream<GridState> _pressSymbolEventToState(
      GridPressSymbolEvent event) async* {
    if (_currBox.isFocus) {
      if (_annotation) {
        List<Symbol> nextAnnotations = _currBox.toggleAnnotation(event.symbol);
        _currBox = _currBox.copyWith(
          symbol: Symbol.none(),
          annotations: nextAnnotations,
        );
      } else {
        _currBox = _currBox.copyWith(symbol: event.symbol, annotations: []);
      }
      yield (state as GridEditable).copyWith(boxList: _boxList);
    }
  }

  Stream<GridState> _pressEraseEventToState(GridPressEraseEvent event) async* {
    if (_currBox.isFocus) {
      _currBox = _currBox.reset().copyWith(isFocus: true);
      yield (state as GridEditable).copyWith(boxList: _boxList);
    }
  }

  Stream<GridState> _buildEventToState(GridBuildingEvent event) async* {
    if (event.state is GridRepoInitial) {
      yield GridInitial(boxList: event.state.boxList);
    } else if (event.state is GridRepoRunning) {
      yield GridCreation(boxList: event.state.boxList);
    } else if (event.state is GridRepoComplete) {
      yield GridEditable(
        boxList: event.state.boxList,
        annotation: _annotation,
        soluce: _soluce,
      );
    }
    _boxList = event.state.boxList;
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
      yield (state as GridEditable).copyWith(boxList: _boxList);
    }
  }
}
