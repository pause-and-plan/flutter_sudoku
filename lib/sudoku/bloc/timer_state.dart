part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);

  bool get canPressPlay {
    if (this is TimerInitial || this is TimerPaused) return true;
    return false;
  }

  @override
  get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial([int duration = 0]) : super(duration);
}

class TimerRunning extends TimerState {
  const TimerRunning(int duration) : super(duration);
}

class TimerPaused extends TimerState {
  const TimerPaused(int duration) : super(duration);
}

class TimerComplete extends TimerState {
  const TimerComplete(int duration) : super(duration);
}
