import 'package:flutter/material.dart';
import 'package:sudoku_v2/sudoku/grid_provider/box_model.dart';
import 'package:sudoku_v2/sudoku/grid_provider/grid_model.dart';
import 'package:sudoku_v2/sudoku/grid_provider/grid_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku app'),
      ),
      body: Center(child: GridView()),
    );
  }
}

class GridView extends StatelessWidget {
  const GridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Grid grid = Grid(
      boxList: List.generate(Grid.length, (_) {
        return Box(availableSymbols: Symbols.list()..shuffle());
      }),
    );
    final gridBuilder = GridBuilder(grid: grid);
    final Stream<GridBuildState> _gridStream = gridBuilder.build();
    return StreamBuilder<GridBuildState>(
      stream: _gridStream,
      builder:
          (BuildContext context, AsyncSnapshot<GridBuildState> buildState) {
        Grid grid = buildState.data?.grid ?? Grid.empty();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(9, (rowIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                9,
                (colIndex) => BoxView(
                  box: grid.boxList[colIndex + rowIndex * 9],
                  isComplete:
                      buildState.data?.status == GridBuildStatus.complete,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class BoxView extends StatelessWidget {
  final Box box;
  final bool isComplete;

  const BoxView({
    required this.isComplete,
    required this.box,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = box.isPuzzle ? Colors.amber : Colors.transparent;
    String text = (box.isPuzzle ? '0' : box.symbol.toString()) + '    ';
    return Container(
      color: color,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}
