import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/constants.dart';
import 'package:sudoku/presenter/game.dart';
import 'package:sudoku/view/widgets/ActionSection.dart';
import 'package:sudoku/view/widgets/LevelAndTimerSection.dart';
import 'package:sudoku/view/widgets/SymbolSection.dart';
import 'package:sudoku/view/widgets/grid/GridSection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

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
              onPress: game.toggleGlobalCheck,
              elevated: game.globalCheckEnable,
            ),
            IconButton(
              onPressed: () => game.resetGrid(),
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Niveau ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Consumer<GamePresenter>(
                                builder: (context, game, child) =>
                                    DropdownButton(
                                  items: List.generate(
                                    5,
                                    (index) => DropdownMenuItem<int>(
                                      value: index,
                                      child: Text(levels[index].label),
                                    ),
                                  ),
                                  value: game
                                      .levelIndex, //levels[game.levelIndex].label,
                                  onChanged: (index) {
                                    game.onChangeLevel(
                                        index is int ? index : 0);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Consumer<GamePresenter>(
                            builder: (context, game, child) =>
                                ElevatedButton.icon(
                              onPressed: () {
                                game.newGame();
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              label: Text(
                                'NOUVELLE PARTIE',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
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
