import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/grid_generator/grid_generator.dart';
import 'package:sudoku/state/app_state.dart';
import 'package:sudoku/view/widgets/menu_dialog.dart';
import 'package:sudoku/view/widgets/shared/MyToggleButton.dart';
import 'package:sudoku/view/widgets/victory_dialog.dart';

class SymbolSection extends StatelessWidget {
  const SymbolSection({Key? key}) : super(key: key);

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
        state.onToggleTimer();
      }
    }

    return Container(
      child: Wrap(
        direction: Axis.horizontal,
        children: List.generate(
          9,
          (index) => Consumer<AppState>(
            builder: (context, state, child) => ToggleSymbolButton(
              symbol: (index + 1).toString(),
              onPress: () {
                state.onPressSymbol(index + 1);
                if (state.grid.isGridFilledWithSuccess()) {
                  _askedLaunchNewGame(state);
                }
              },
              elevated: state.grid.shouldElevateSymbolButton(index + 1),
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleSymbolButton extends StatelessWidget {
  final String symbol;
  final VoidCallback onPress;
  final bool elevated;
  const ToggleSymbolButton({
    this.symbol = '',
    required this.onPress,
    required this.elevated,
  });

  @override
  Widget build(BuildContext context) {
    return MyToggleButton(
      child: Text(
        symbol,
        style: TextStyle(color: Colors.black54, fontSize: 18),
      ),
      onPress: onPress,
      elevated: elevated,
      size: 36,
      padding: 2,
    );
  }
}
