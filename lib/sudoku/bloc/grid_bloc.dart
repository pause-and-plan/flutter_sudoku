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
    }
    if (event is GridBuildingEvent) {
      yield* _buildEventToState(event);
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
}
