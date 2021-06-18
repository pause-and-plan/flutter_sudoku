import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/state/app_state.dart';
import 'package:sudoku/state/timer_state.dart';

class LevelAndTimerSection extends StatelessWidget {
  const LevelAndTimerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: Consumer<AppState>(
              builder: (context, state, child) => Text(
                state.grid.getLevelLabel(),
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          Consumer<AppState>(
            builder: (context, state, child) => Row(
              children: [
                Text(
                  state.timer.getFormatedDuration(),
                  style: TextStyle(color: Colors.black87),
                ),
                IconButton(
                  onPressed: state.onToggleTimer,
                  icon: Icon(
                    state.timer.status == TimerStatus.running
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
