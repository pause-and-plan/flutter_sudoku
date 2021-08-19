part of 'timer_bloc.dart';

enum TimerStatus { initial, running, paused, complete }

class TimerState extends Equatable {
  final TimerStatus status;
  final int duration;
  get isInitial => status == TimerStatus.initial;
  get isRunning => status == TimerStatus.running;
  get isPaused => status == TimerStatus.paused;
  get isComplete => status == TimerStatus.complete;

  const TimerState({required this.duration, required this.status});
  const TimerState.initial() : this(duration: 0, status: TimerStatus.initial);
  const TimerState.running(int duration)
      : this(duration: duration, status: TimerStatus.running);
  const TimerState.paused(int duration)
      : this(duration: duration, status: TimerStatus.paused);
  const TimerState.complete(int duration)
      : this(duration: duration, status: TimerStatus.complete);

  bool get canPressPlay {
    if (this.isInitial || this.isPaused) return true;
    return false;
  }

  @override
  get props => [duration, status];

  TimerState copyWith({TimerStatus? status, int? duration}) {
    return TimerState(
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }

  factory TimerState.fromJson(Map<String, dynamic> json) {
    int duration = json['duration'] != null ? json['duration'] as int : 0;
    TimerStatus? status =
        EnumToString.fromString(TimerStatus.values, json['status']);

    return TimerState(
      duration: duration,
      status: status != null ? status : TimerStatus.initial,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'status': EnumToString.convertToString(status)
    };
  }
}

// class TimerInitial extends TimerState {
//   const TimerInitial([int duration = 0]) : super(duration);

//   factory TimerInitial.fromJson(Map<String, dynamic> json) {
//     int duration = json['duration'] != null ? json['duration'] as int : 0;
//     return TimerInitial(duration);
//   }
// }

// class TimerRunning extends TimerState {
//   const TimerRunning(int duration) : super(duration);

//   factory TimerRunning.fromJson(Map<String, dynamic> json) {
//     int duration = json['duration'] != null ? json['duration'] as int : 0;
//     return TimerRunning(duration);
//   }
// }

// class TimerPaused extends TimerState {
//   const TimerPaused(int duration) : super(duration);

//   factory TimerPaused.fromJson(Map<String, dynamic> json) {
//     int duration = json['duration'] != null ? json['duration'] as int : 0;
//     return TimerPaused(duration);
//   }
// }

// class TimerComplete extends TimerState {
//   const TimerComplete(int duration) : super(duration);

//   factory TimerComplete.fromJson(Map<String, dynamic> json) {
//     int duration = json['duration'] != null ? json['duration'] as int : 0;
//     return TimerComplete(duration);
//   }
// }
