import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/constants.dart';
import 'package:sudoku/presenter/game.dart';

class LevelAndTimerSection extends StatelessWidget {
  const LevelAndTimerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startDateTime = DateTime.now();
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: Consumer<GamePresenter>(
              builder: (context, game, child) => Text(
                levels[game.levelIndex].label,
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                DateTimeRange(start: startDateTime, end: DateTime.now())
                    .duration
                    .inSeconds
                    .toString(),
                style: TextStyle(color: Colors.black87),
              ),
              IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.pause_circle_outline,
                  color: Colors.black54,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
