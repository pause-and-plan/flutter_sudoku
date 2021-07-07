import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sudoku_v2/sudoku/grid_provider/grid_provider.dart';

part 'grid_event.dart';
part 'grid_state.dart';

class GridBloc extends Bloc<GridEvent, GridState> {
  final Stream<GridBuildState> buildStream;
  GridBloc({required this.buildStream}) : super(GridInitial()) {
    buildStream.listen((GridBuildState event) {
      add(GridEvent(state: event));
    });
  }

  @override
  Stream<GridState> mapEventToState(
    GridEvent event,
  ) async* {
    yield GridState(state: event.state);
  }
}
