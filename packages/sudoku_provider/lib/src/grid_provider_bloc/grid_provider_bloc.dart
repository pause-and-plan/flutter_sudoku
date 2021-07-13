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
  StreamSubscription? _generatorStream;
  StreamSubscription? _puzzlerStream;

  GridProviderBloc() : super(GridProviderInitial()) {
    generatorBloc = GridGeneratorBloc();
    puzzlerBloc = GridPuzzlerBloc();
  }

  @override
  Stream<GridProviderState> mapEventToState(GridProviderEvent event) async* {
    if (event is GridProviderStartEvent) {
      _startEventToState(event);
    } else if (event is GridProviderRunningEvent) {
      yield* _runningEventToState(event);
    } else if (event is GridProviderCompleteEvent) {
      yield* _completeEventToState(event);
    }
  }

  _startEventToState(GridProviderStartEvent event) {
    level = event.level;
    _subscribeGenerator();
    generatorBloc.add(GridGeneratorStartEvent());
  }

  _subscribeGenerator() {
    _generatorStream = generatorBloc.stream.listen((GridGeneratorState state) {
      if (state is GridGeneratorRunning) {
        List<BoxPuzzled> boxList = state.boxList.map((box) {
          return BoxPuzzled.disable(symbol: box.symbol);
        }).toList();
        add(GridProviderRunningEvent(
          boxList: boxList,
          step: GridProviderStep.fill,
          stepPercent: state.progression,
        ));
      } else if (state is GridGeneratorComplete) {
        _unsubscribeGenerator();
        _subscribePuzzler();
        List<BoxPuzzled> boxList = state.boxList.map((box) {
          return BoxPuzzled.disable(symbol: box.symbol);
        }).toList();
        puzzlerBloc.add(GridPuzzlerStartEvent(boxList: boxList, level: level));
      }
    });
  }

  _unsubscribeGenerator() => _generatorStream?.cancel();

  _subscribePuzzler() {
    _puzzlerStream = puzzlerBloc.stream.listen((GridPuzzlerState state) {
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
        _unsubscribePuzzler();
      }
    });
  }

  _unsubscribePuzzler() => _puzzlerStream?.cancel();

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
