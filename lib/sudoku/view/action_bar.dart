import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GridBloc gridBloc = context.read<GridBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => gridBloc.add(GridResetEvent()),
          icon: Icon(Icons.refresh),
        ),
        IconButton(
          onPressed: () => gridBloc.add(GridPressCheckEvent()),
          icon: context.select((GridBloc bloc) => bloc.state.soluce)
              ? Icon(Icons.check, color: Colors.blue)
              : Icon(Icons.check),
        ),
        IconButton(
          onPressed: () => gridBloc.add(GridPressAnnotationEvent()),
          icon: context.select((GridBloc bloc) => bloc.state.annotation)
              ? Icon(Icons.edit, color: Colors.blue)
              : Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () => gridBloc.add(GridUndoEvent()),
          icon: Icon(Icons.undo),
        ),
      ],
    );
  }
}
