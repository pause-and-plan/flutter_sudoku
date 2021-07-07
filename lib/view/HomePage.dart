import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/grid_generator/grid_generator.dart';
import 'package:sudoku/state/app_state.dart';
import 'package:sudoku/view/widgets/ActionSection.dart';
import 'package:sudoku/view/widgets/LevelAndTimerSection.dart';
import 'package:sudoku/view/widgets/SymbolSection.dart';
import 'package:sudoku/view/widgets/grid/GridSection.dart';
import 'package:sudoku/view/widgets/menu_dialog.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

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

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'Sudoku',
          style: TextStyle(
              color: Colors.black54,
              fontSize: 32,
              fontWeight: FontWeight.normal),
        ),
        actions: [
          Consumer<AppState>(
            builder: (context, state, child) => ToggleIconButton(
              icon: Icons.done_all,
              onPress: state.onPressGlobalCheck,
              elevated: state.grid.globalCheckEnable,
            ),
          ),
          IconButton(
            onPressed:
                Provider.of<AppState>(context, listen: false).onPressResetGrid,
            icon: Icon(Icons.refresh),
          ),
          Consumer<AppState>(
            builder: (context, state, child) => IconButton(
              onPressed: () => _askedNewGameDifficulty(state),
              icon: Icon(Icons.settings),
            ),
          ),
        ],
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(children: [
                  LevelAndTimerSection(),
                  GridSection(),
                ]),
                SizedBox(height: 40),
                SymbolSection(),
                SizedBox(height: 20),
                ActionsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
