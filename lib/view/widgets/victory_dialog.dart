import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/state/app_state.dart';

class VictoryDialog extends StatelessWidget {
  const VictoryDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) => SimpleDialog(
        title: Center(child: Text('Victoire')),
        children: <Widget>[
          SizedBox(height: 10),
          Center(child: Text('Niveau ' + state.grid.getLevelLabel())),
          SizedBox(height: 10),
          Center(child: Text('Temps ' + state.timer.getFormatedDuration())),
          SizedBox(height: 40),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Center(child: Text('REJOUER')),
          ),
        ],
      ),
    );
  }
}
