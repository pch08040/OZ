import 'dart:async';

import 'package:flutter/material.dart';

class TimeProvider extends ChangeNotifier {
  static const totalTime = 5;
  int totalSeconds = totalTime;
  bool isRunning = false;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      totalSeconds = totalTime;
      isRunning = true;
      timer.cancel();
    } else {
      totalSeconds = totalSeconds - 1;
    }
    // ChangeNotifier를 listen하는 모든 위젯들에게 데이터가 변경될때 마다 그 사실을 알려줌
    notifyListeners();
  }

  void timerStart() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      onTick,
    );
    isRunning = false;
    notifyListeners();
  }

}
