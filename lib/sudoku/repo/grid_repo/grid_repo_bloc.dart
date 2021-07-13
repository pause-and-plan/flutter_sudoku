import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sudoku/sudoku/model/box_model.dart';
import 'package:sudoku_provider/sudoku_provider.dart';

part 'grid_repo_event.dart';
part 'grid_repo_state.dart';

class GridRepoBloc extends Bloc<GridRepoEvent, GridRepoState> {
  final GridProviderBloc providerBloc = GridProviderBloc();
  StreamSubscription? _providerStream;

  GridRepoBloc() : super(GridRepoInitial(GridRepoInitial.initialBoxList()));

  @override
  Stream<GridRepoState> mapEventToState(
    GridRepoEvent event,
  ) async* {
    if (event is GridRepoStartEvent) {
      _startSubscription(event);
    } else if (event is GridRepoRunningEvent) {
      yield* _runningEventToState(event);
    } else if (event is GridRepoCompleteEvent) {
      yield* _completeEventToState(event);
    }
  }

  _startSubscription(GridRepoStartEvent event) {
    _providerStream = providerBloc.stream.listen((GridProviderState state) {
      if (state is GridProviderRunning) {
        add(GridRepoRunningEvent(boxList: state.boxList));
      } else if (state is GridProviderComplete) {
        add(GridRepoCompleteEvent(boxList: state.boxList));
      }
    });
    providerBloc.add(GridProviderStartEvent(level: event.level));
  }

  Stream<GridRepoState> _runningEventToState(
      GridRepoRunningEvent event) async* {
    yield GridRepoRunning(_adaptBoxList(event.boxList));
  }

  Stream<GridRepoState> _completeEventToState(
      GridRepoCompleteEvent event) async* {
    yield GridRepoComplete(_adaptBoxList(event.boxList));
    _stopSubscription();
  }

  _stopSubscription() => _providerStream?.cancel();

  List<Box> _adaptBoxList(List<BoxPuzzled> boxList) {
    return boxList.map((BoxPuzzled box) {
      if (box.disable) {
        return Box.disable(soluce: box.symbol);
      } else {
        return Box.puzzle(soluce: box.symbol);
      }
    }).toList();
  }
}
