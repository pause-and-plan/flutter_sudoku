import 'dart:async';

enum TimerStatus {
  running,
  paused,
  stopped,
}

class MyTimer {
  int durationInSeconds = 0;
  TimerStatus status = TimerStatus.running;

  MyTimer(Function notifyListener) {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_shouldIncrementDuration()) {
        _incrementDuration();
        notifyListener();
      }
    });
  }

  void togglePlayPause() {
    if (status == TimerStatus.running) {
      status = TimerStatus.paused;
    } else {
      status = TimerStatus.running;
    }
  }

  void play() {
    bool shouldResetDuration = status == TimerStatus.stopped;
    if (shouldResetDuration) {
      durationInSeconds = 0;
    }
    status = TimerStatus.running;
  }

  void pause() => status = TimerStatus.paused;
  void stop() => status = TimerStatus.stopped;
  void reset() {
    stop();
    play();
  }

  String getFormatedDuration() {
    String formatedDuration = '';
    Duration duration = Duration(seconds: durationInSeconds);
    formatedDuration += duration.inMinutes.toString();
    formatedDuration += ':';
    formatedDuration += (duration.inSeconds % 60).toString();
    return formatedDuration;
  }

  bool _shouldIncrementDuration() => status == TimerStatus.running;
  void _incrementDuration() => durationInSeconds++;
}
