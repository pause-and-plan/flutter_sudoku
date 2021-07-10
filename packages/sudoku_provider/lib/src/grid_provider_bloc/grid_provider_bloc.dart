import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../grid_generator_bloc/grid_generator_bloc.dart';
import '../grid_puzzler_bloc/grid_puzzler_bloc.dart';
import '../helpers/grid.dart';
import '../models/box_model.dart';

part 'grid_provider_event.dart';
part 'grid_provider_state.dart';

class GridProviderBloc extends Bloc<GridProviderEvent, GridProviderState> {
  late GridGeneratorBloc generatorBloc;
  late GridPuzzlerBloc puzzlerBloc;
  late GridLevel level;

  GridProviderBloc() : super(GridProviderInitial()) {
    generatorBloc = GridGeneratorBloc();
    puzzlerBloc = GridPuzzlerBloc();
  }

  @override
  Stream<GridProviderState> mapEventToState(GridProviderEvent event) async* {
    if (event is GridProviderStartEvent) {
      yield _startEventToState(event);
    } else if (event is GridProviderRunningEvent) {
      yield* _runningEventToState(event);
    } else if (event is GridProviderCompleteEvent) {
      yield* _completeEventToState(event);
    }
  }

  GridProviderState _startEventToState(GridProviderStartEvent event) {
    level = event.level;
    _listenGenerator();
    generatorBloc.add(GridGeneratorStartEvent());
    return GridProviderInitial();
  }

  _listenGenerator() {
    generatorBloc.stream.listen((GridGeneratorState state) {
      if (state is GridGeneratorRunning) {
        add(GridProviderRunningEvent(
          boxList: state.boxList,
          step: GridProviderStep.fill,
          stepPercent: state.progression,
        ));
      } else if (state is GridGeneratorComplete) {
        _listenPuzzler();
        List<BoxPuzzled> boxList = state.boxList.map((box) {
          return BoxPuzzled.disable(symbol: box.symbol);
        }).toList();
        puzzlerBloc.add(GridPuzzlerStartEvent(boxList: boxList, level: level));
      }
    });
  }

  _listenPuzzler() {
    puzzlerBloc.stream.listen((GridPuzzlerState state) {
      if (state is GridPuzzlerRunning) {
        add(GridProviderRunningEvent(
          boxList: state.boxList,
          step: GridProviderStep.puzzle,
          stepPercent: state.progression,
        ));
      } else if (state is GridPuzzlerComplete) {
        add(GridProviderCompleteEvent(
          boxList: state.boxList,
          step: GridProviderStep.puzzle,
        ));
      }
    });
  }

  Stream<GridProviderState> _runningEventToState(
      GridProviderRunningEvent event) async* {
    yield GridProviderRunning(
      boxList: event.boxList,
      step: event.step,
      stepPercent: event.stepPercent,
    );
  }

  Stream<GridProviderState> _completeEventToState(
      GridProviderCompleteEvent event) async* {
    yield GridProviderComplete(boxList: event.boxList, step: event.step);
  }
}
