import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/view/action_bar.dart';
import 'package:sudoku/sudoku/view/grid_view.dart';
import 'package:sudoku/sudoku/view/symbol_bar.dart';
import 'package:sudoku_provider/sudoku_provider.dart';
import 'package:sizer/sizer.dart';

class GridPage extends StatelessWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku'),
        actions: [],
      ),
      backgroundColor: Colors.grey.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => context
                .read<GridBloc>()
                .add(GridBuildEvent(GridLevel.beginner)),
            child: Text('new grid'),
          ),
          GridWidget(),
          SizedBox(height: 2.h),
          SymbolBar(),
          SizedBox(height: 2.h),
          ActionBar(),
        ],
      ),
    );
  }
}
