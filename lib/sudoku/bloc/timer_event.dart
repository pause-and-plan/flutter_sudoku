part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();
  get props => [];
}

class TimerPlayEvent extends TimerEvent {
  TimerPlayEvent();
}

class TimerTickEvent extends TimerEvent {
  final int duration;
  TimerTickEvent(this.duration);

  @override
  get props => [duration];
}

class TimerRehydrateEvent extends TimerEvent {
  final TimerState rehydratedState;
  TimerRehydrateEvent(this.rehydratedState);

  @override
  get props => [rehydratedState];
}

class TimerPauseEvent extends TimerEvent {}

class TimerResumeEvent extends TimerEvent {}

class TimerStopEvent extends TimerEvent {}

class TimerResetEvent extends TimerEvent {}
