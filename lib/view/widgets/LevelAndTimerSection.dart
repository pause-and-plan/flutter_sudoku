import 'package:flutter/material.dart';

class LevelAndTimerSection extends StatelessWidget {
  const LevelAndTimerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridLevel = 'facile';
    final startDateTime = DateTime.now();
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              gridLevel,
              style: TextStyle(color: Colors.black87),
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
