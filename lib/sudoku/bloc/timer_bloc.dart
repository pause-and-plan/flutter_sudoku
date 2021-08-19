import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends HydratedBloc<TimerEvent, TimerState> {
  StreamSubscription<int>? _tickSubscription;
  TimerBloc() : super(TimerState.initial());

  bool get enable => !(state.isComplete);

  void onPressPlayPause() {
    if (state.isInitial) {
      add(TimerPlayEvent());
    } else if (state.isRunning) {
      add(TimerPauseEvent());
    } else if (state.isPaused) {
      add(TimerResumeEvent());
    }
  }

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is TimerPlayEvent) {
      yield* _playEventToState(event);
    } else if (event is TimerTickEvent) {
      yield* _tickEventToState(event);
    } else if (event is TimerPauseEvent) {
      yield* _pauseEventToState(event);
    } else if (event is TimerResumeEvent) {
      yield* _resumeEventToState(event);
    } else if (event is TimerStopEvent) {
      yield* _stopEventToState(event);
    } else if (event is TimerResetEvent) {
      yield* _resetEventToState(event);
    } else if (event is TimerRehydrateEvent) {
      yield* _rehydrateEventToState(event);
    }
  }

  Stream<TimerState> _playEventToState(TimerPlayEvent event) async* {
    _tickSubscription?.cancel();
    Stream<int> stream = Ticker().ticks(state.duration);
    _tickSubscription = stream.listen((int remainingDuration) {
      add(TimerTickEvent(remainingDuration));
    });
  }

  Stream<TimerState> _rehydrateEventToState(TimerRehydrateEvent event) async* {
    TimerState lastState = event.rehydratedState;
    if (lastState.isRunning || lastState.isPaused) {
      Stream<int> stream = Ticker().ticks(lastState.duration);
      _tickSubscription?.cancel();
      _tickSubscription = stream.listen((int duration) {
        add(TimerTickEvent(duration));
      });
      if (lastState.isPaused) {
        _tickSubscription?.pause();
      }
    }
  }

  Stream<TimerState> _tickEventToState(TimerTickEvent event) async* {
    yield TimerState.running(event.duration);
  }

  Stream<TimerState> _pauseEventToState(TimerPauseEvent event) async* {
    if (state.isRunning) {
      _tickSubscription?.pause();
      yield TimerState.paused(state.duration);
    }
  }

  Stream<TimerState> _resumeEventToState(TimerResumeEvent event) async* {
    if (state.isPaused) {
      _tickSubscription?.resume();
      yield TimerState.running(state.duration);
    }
  }

  Stream<TimerState> _stopEventToState(TimerStopEvent event) async* {
    _tickSubscription?.cancel();
    yield TimerState.complete(state.duration);
  }

  Stream<TimerState> _resetEventToState(TimerResetEvent event) async* {
    _tickSubscription?.cancel();
    yield TimerState.initial();
  }

  @override
  TimerState fromJson(Map<String, dynamic> json) {
    TimerState nextState = TimerState.fromJson(json);
    add(TimerRehydrateEvent(nextState));
    return nextState;
  }

  @override
  Map<String, dynamic> toJson(TimerState state) => state.toJson();
}

class Ticker {
  Stream<int> ticks([int offset = 0]) {
    Duration period = Duration(seconds: 1);
    int getDuration(int tickIndex) => tickIndex + 1 + offset;
    return Stream.periodic(period, getDuration);
  }
}
