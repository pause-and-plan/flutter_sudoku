import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sudoku_provider/models/box_generator_model.dart';
import 'package:sudoku_provider/models/grid_model.dart';

part 'grid_generator_event.dart';
part 'grid_generator_state.dart';

class GridGeneratorBloc extends Bloc<GridGeneratorEvent, GridGeneratorState> {
  late List<BoxGenerator> boxList;
  late int _currIndex;
  BoxGenerator get _currBox => boxList[_currIndex];

  GridGeneratorBloc() : super(GridGeneratorInitial());

  @override
  Stream<GridGeneratorState> mapEventToState(
    GridGeneratorEvent event,
  ) async* {
    if (event is GenerateGridEvent) {
      yield* _generateEventToState();
    }
  }

  Stream<GridGeneratorState> _generateEventToState() async* {
    _initialize();
  }

  _initialize() {
    boxList = List.generate(Grid.length, (_) => BoxGenerator.unordered());
    _currIndex = 0;
  }
}
