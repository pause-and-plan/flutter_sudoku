import 'dart:async';
import 'package:flutter/material.dart';

class MyTimer extends ChangeNotifier {
  int durationInSeconds = 0;
  bool isRunning = true;
  bool isPaused = false;

  MyTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_shouldIncrementDuration()) {
        _incrementDuration();
        notifyListeners();
      }
    });
  }

  togglePlayPause() {
    if (isPaused) {
      play();
    } else {
      pause();
    }
  }

  play() {
    if (_shouldResetDuration()) _resetDuration();
    isPaused = false;
    isRunning = true;
    notifyListeners();
  }

  pause() {
    isPaused = true;
    isRunning = false;
    notifyListeners();
  }

  stop() {
    isRunning = false;
    isPaused = false;
    notifyListeners();
  }

  reset() {
    stop();
    play();
  }

  getFormatedDuration() {
    String formatedDuration = '';
    Duration duration = Duration(seconds: durationInSeconds);
    formatedDuration += duration.inMinutes.toString();
    formatedDuration += ':';
    formatedDuration += (duration.inSeconds % 60).toString();
    return formatedDuration;
  }

  _shouldResetDuration() => isPaused ? false : true;
  _resetDuration() => durationInSeconds = 0;

  _shouldIncrementDuration() => isRunning;
  _incrementDuration() => durationInSeconds++;
}
