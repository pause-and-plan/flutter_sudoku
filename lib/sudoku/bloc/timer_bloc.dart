import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  StreamSubscription<int>? _tickSubscription;
  TimerBloc() : super(TimerInitial());

  void onPressPlayPause() {
    if (state is TimerInitial) {
      add(TimerPlayEvent());
    } else if (state is TimerRunning) {
      add(TimerPauseEvent());
    } else if (state is TimerPaused) {
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
    } else if (event is TimerResetEvent) {
      yield* _resetEventToState(event);
    }
  }

  Stream<TimerState> _playEventToState(TimerPlayEvent event) async* {
    _tickSubscription?.cancel();
    Stream<int> stream = Ticker().ticks();
    _tickSubscription = stream.listen((int remainingDuration) {
      add(TimerTickEvent(remainingDuration));
    });
  }

  Stream<TimerState> _tickEventToState(TimerTickEvent event) async* {
    yield TimerRunning(event.duration);
  }

  Stream<TimerState> _pauseEventToState(TimerPauseEvent event) async* {
    if (state is TimerRunning) {
      _tickSubscription?.pause();
      yield TimerPaused(state.duration);
    }
  }

  Stream<TimerState> _resumeEventToState(TimerResumeEvent event) async* {
    if (state is TimerPaused) {
      _tickSubscription?.resume();
      yield TimerRunning(state.duration);
    }
  }

  Stream<TimerState> _resetEventToState(TimerResetEvent event) async* {
    _tickSubscription?.cancel();
    yield TimerInitial();
  }
}

class Ticker {
  Stream<int> ticks() {
    Duration period = Duration(seconds: 1);
    int getDuration(int tickIndex) => tickIndex + 1;
    return Stream.periodic(period, getDuration);
  }
}
