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
          onPressed: () async {
            bool? shouldDebugGrid = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => ConfirmDebugIntent(),
            );
            if (shouldDebugGrid != null && shouldDebugGrid) {
              gridBloc.add(TestGridWinEvent());
            }
          },
          icon: Icon(Icons.bug_report),
        ),
        IconButton(
          onPressed: () async {
            bool? shouldResetGrid = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) => ConfirmResetIntent(),
            );
            if (shouldResetGrid != null && shouldResetGrid) {
              gridBloc.add(GridResetEvent());
            }
          },
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

class ConfirmResetIntent extends StatelessWidget {
  const ConfirmResetIntent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Recommencer'),
      content: const Text('La grille va être réinitialisé'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('ANNULER'),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('CONFIRMER'),
        ),
      ],
    );
  }
}

class ConfirmDebugIntent extends StatelessWidget {
  const ConfirmDebugIntent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Debug'),
      content: const Text('La grille va être remplie'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('ANNULER'),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('CONFIRMER'),
        ),
      ],
    );
  }
}
