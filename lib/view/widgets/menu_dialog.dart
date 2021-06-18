import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/grid_generator/grid_generator.dart';
import 'package:sudoku/state/app_state.dart';

class MenuDialog extends StatelessWidget {
  final String title;
  const MenuDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) => SimpleDialog(
        title: Center(child: Text(title)),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, GridLevel.beginner);
            },
            child: Center(child: Text('debutant')),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, GridLevel.easy);
            },
            child: Center(child: Text('facile')),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, GridLevel.medium);
            },
            child: Center(child: Text('moyen')),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, GridLevel.advanced);
            },
            child: Center(child: Text('difficile')),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, GridLevel.expert);
            },
            child: Center(child: Text('expert')),
          ),
        ],
      ),
    );
  }
}
