import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          Consumer<GamePresenter>(
            builder: (context, game, child) => ToggleIconButton(
              icon: Icons.done_all,
              onPress: game.toggleGlobalCheck,
              elevated: game.globalCheckEnable,
            ),
          ),
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => {},
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
