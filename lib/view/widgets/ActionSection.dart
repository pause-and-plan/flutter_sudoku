import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/presenter/game.dart';
import 'package:sudoku/view/widgets/shared/MyToggleButton.dart';

class ActionsSection extends StatelessWidget {
  const ActionsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceAround,
        children: [
          Consumer<GamePresenter>(
            builder: (context, game, child) => IconButton(
              icon: Icon(Icons.undo),
              onPressed: game.undo,
            ),
          ),
          Consumer<GamePresenter>(
            builder: (context, game, child) => ToggleIconButton(
              icon: Icons.check,
              onPress: game.currentBoxToggleCheck,
              elevated: game.currentBox.checkEnable,
            ),
          ),
          Consumer<GamePresenter>(
            builder: (context, game, child) => ToggleIconButton(
              icon: Icons.edit,
              onPress: game.currentBoxToggleAnnotations,
              elevated: game.currentBox.annotationsEnable,
            ),
          ),
          Consumer<GamePresenter>(
            builder: (context, game, child) => IconButton(
              icon: Icon(Icons.wb_incandescent),
              onPressed: game.currentBoxApplySoluce,
            ),
          ),
          Consumer<GamePresenter>(
            builder: (context, game, child) => IconButton(
              icon: Icon(Icons.redo),
              onPressed: game.redo,
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
