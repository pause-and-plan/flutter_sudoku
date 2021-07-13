import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/view/grid_view.dart';
import 'package:sudoku_provider/sudoku_provider.dart';

class GridPage extends StatelessWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sudoku')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridWidget(),
          ElevatedButton(
            onPressed: () => context
                .read<GridBloc>()
                .add(GridBuildEvent(GridLevel.beginner)),
            child: Text('new grid'),
          )
        ],
      ),
    );
  }
}
