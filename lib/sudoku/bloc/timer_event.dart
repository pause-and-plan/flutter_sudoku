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

class TimerPauseEvent extends TimerEvent {}

class TimerResumeEvent extends TimerEvent {}

class TimerStopEvent extends TimerEvent {}

class TimerResetEvent extends TimerEvent {}
