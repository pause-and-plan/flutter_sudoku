import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/presenter/game.dart';
import 'package:sudoku/presenter/timerPresenter.dart';

class LevelAndTimerSection extends StatelessWidget {
  const LevelAndTimerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: Consumer<GamePresenter>(
              builder: (context, game, child) => Text(
                game.getLevelLabel(),
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          Consumer<MyTimer>(
            builder: (context, timer, child) => Row(
              children: [
                Text(
                  timer.getFormatedDuration(),
                  style: TextStyle(color: Colors.black87),
                ),
                IconButton(
                  onPressed: timer.togglePlayPause,
                  icon: Icon(
                    timer.isRunning
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
