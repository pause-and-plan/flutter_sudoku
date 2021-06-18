import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/grid_generator/grid_generator.dart';
import 'package:sudoku/state/app_state.dart';
import 'package:sudoku/view/widgets/menu_dialog.dart';
import 'package:sudoku/view/widgets/shared/MyToggleButton.dart';
import 'package:sudoku/view/widgets/victory_dialog.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _askedNewGameDifficulty(AppState state) async {
      GridLevel? level = await showDialog<GridLevel>(
          context: context,
          builder: (BuildContext context) {
            return MenuDialog(title: 'Nouvelle partie');
          });
      if (level != null) {
        state.createNewGrid(level);
      }
    }

    Future<void> _askedLaunchNewGame(AppState state) async {
      bool? shouldLaunchNewGame = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return VictoryDialog();
          });
      if (shouldLaunchNewGame != null && shouldLaunchNewGame) {
        _askedNewGameDifficulty(state);
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceAround,
        children: [
          Consumer<AppState>(
            builder: (context, state, child) => IconButton(
              icon: Icon(Icons.undo),
              onPressed: () {
                state.onPressUndo();
              },
            ),
          ),
          Consumer<AppState>(
            builder: (context, state, child) => ToggleIconButton(
              icon: Icons.check,
              onPress: state.onPressBoxCheck,
              elevated: state.grid.currentBox.checkEnable,
            ),
          ),
          Consumer<AppState>(
            builder: (context, state, child) => ToggleIconButton(
              icon: Icons.edit,
              onPress: state.onPressBoxAnnotation,
              elevated: state.grid.currentBox.annotationsEnable,
            ),
          ),
          Consumer<AppState>(
            builder: (context, state, child) => IconButton(
              icon: Icon(Icons.auto_fix_high_sharp),
              onPressed: () {
                state.onPressBoxReset();
              },
            ),
          ),
          Consumer<AppState>(
            builder: (context, state, child) => IconButton(
              icon: Icon(Icons.wb_incandescent),
              onPressed: () {
                state.onPressBoxSoluce();
                if (state.grid.isGridFilledWithSuccess()) {
                  state.onToggleTimer();
                  _askedLaunchNewGame(state);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ToggleIconButton extends StatelessWidget {
  final IconData icon;
  final bool elevated;
  final VoidCallback onPress;
  const ToggleIconButton({
    this.icon = Icons.cancel,
    this.elevated = false,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return MyToggleButton(
      child: Icon(
        icon,
        color: Colors.black54,
      ),
      elevated: elevated,
      onPress: onPress,
    );
  }
}
