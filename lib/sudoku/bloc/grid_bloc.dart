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
    }
  }

  Stream<GridState> _pressSymbolEventToState(
      GridPressSymbolEvent event) async* {
    if (_currBox.isFocus) {
      _currBox = _currBox.copyWith(symbol: event.symbol);
      yield GridEditable(boxList: _boxList, annotations: _annotation);
    }
  }

  Stream<GridState> _pressEraseEventToState(GridPressEraseEvent event) async* {
    if (_currBox.isFocus) {
      _currBox = _currBox.reset().copyWith(isFocus: true);
      yield GridEditable(boxList: _boxList, annotations: _annotation);
    }
  }

  Stream<GridState> _buildEventToState(GridBuildingEvent event) async* {
    if (event.state is GridRepoInitial) {
      yield GridInitial(boxList: event.state.boxList);
    } else if (event.state is GridRepoRunning) {
      yield GridCreation(boxList: event.state.boxList);
    } else if (event.state is GridRepoComplete) {
      yield GridEditable(
          boxList: event.state.boxList, annotations: _annotation);
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
      yield GridEditable(boxList: _boxList, annotations: _annotation);
    }
  }

  setBox(int index, Box box) {
    List<Box> next = [..._boxList];
    next[index] = box;
    _boxList = next;
  }
}
