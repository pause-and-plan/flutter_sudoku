import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/presenter/game.dart';
import 'package:sudoku/view/widgets/shared/MyToggleButton.dart';

class SymbolSection extends StatelessWidget {
  const SymbolSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        direction: Axis.horizontal,
        children: List.generate(
          9,
          (index) => Consumer<GamePresenter>(
            builder: (context, game, child) => ToggleSymbolButton(
              symbol: (index + 1).toString(),
              onPress: () => game.onPressSymbol(index + 1),
              elevated: game.currentBox.shouldElevateSymbolButton(index + 1),
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
    );
  }
}
