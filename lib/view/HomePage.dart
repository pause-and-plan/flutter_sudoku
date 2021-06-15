import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/presenter/game.dart';
import 'package:sudoku/presenter/timerPresenter.dart';
import 'package:sudoku/view/widgets/ActionSection.dart';
import 'package:sudoku/view/widgets/LevelAndTimerSection.dart';
import 'package:sudoku/view/widgets/SymbolSection.dart';
import 'package:sudoku/view/widgets/grid/GridSection.dart';

class HomePage extends StatefulWidget {
  final GamePresenter game;
  final MyTimer timer;

  const HomePage({
    Key? key,
    required this.game,
    required this.timer,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Future<void> _askedNewGameDifficulty() async {
      int? nextLevelIndex = await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return MenuDialog(title: 'Nouvelle partie');
          });
      if (nextLevelIndex != null) {
        widget.game.newGame(nextLevelIndex);
        widget.timer.reset();
      }
    }

    Future<void> _askedLaunchNewGame() async {
      bool? shouldLaunchNewGame = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return WinDialog();
          });
      if (shouldLaunchNewGame != null && shouldLaunchNewGame) {
        _askedNewGameDifficulty();
      } else {
        widget.game.disableVictory();
      }
    }

    return Consumer<GamePresenter>(
      builder: (context, game, child) => Scaffold(
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
            ToggleIconButton(
              icon: Icons.done_all,
              onPress: () {
                game.toggleGlobalCheck();
                if (game.isVictory) {
                  _askedLaunchNewGame();
                  widget.timer.stop();
                }
              },
              elevated: game.globalCheckEnable,
            ),
            IconButton(
              onPressed: () {
                game.resetGrid();
                widget.timer.reset();
              },
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: _askedNewGameDifficulty,
              icon: Icon(Icons.settings),
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
                  Consumer<GamePresenter>(
                      builder: (context, game, child) => game.loading
                          ? LinearProgressIndicator()
                          : SizedBox()),
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
      ),
    );
  }
}

class MenuDialog extends StatelessWidget {
  final String title;
  const MenuDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePresenter>(
      builder: (context, game, child) => SimpleDialog(
        title: Center(child: Text(title)),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 0);
            },
            child: Center(child: Text(game.levels.getLabel(0))),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 1);
            },
            child: Center(child: Text(game.levels.getLabel(1))),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 2);
            },
            child: Center(child: Text(game.levels.getLabel(2))),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 3);
            },
            child: Center(child: Text(game.levels.getLabel(3))),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 4);
            },
            child: Center(child: Text(game.levels.getLabel(4))),
          ),
        ],
      ),
    );
  }
}

class WinDialog extends StatelessWidget {
  const WinDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePresenter>(
      builder: (context, game, child) => Consumer<MyTimer>(
        builder: (context, timer, child) => SimpleDialog(
          title: Center(child: Text('Victoire')),
          children: <Widget>[
            SizedBox(height: 10),
            Center(child: Text('Niveau ' + game.getLevelLabel())),
            SizedBox(height: 10),
            Center(child: Text('Temps ' + timer.getFormatedDuration())),
            SizedBox(height: 40),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Center(child: Text('REJOUER')),
            ),
          ],
        ),
      ),
    );
  }
}
