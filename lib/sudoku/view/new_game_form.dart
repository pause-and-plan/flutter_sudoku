import 'package:flutter/material.dart';
import 'package:sudoku/navigation/bloc/nav_bloc.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/bloc/timer_bloc.dart';
import 'package:sudoku/widgets/selector/selector_view.dart';
import 'package:sudoku_provider/sudoku_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class NewGameForm extends StatefulWidget {
  const NewGameForm({Key? key}) : super(key: key);

  @override
  _NewGameFormState createState() => _NewGameFormState();
}

class _NewGameFormState extends State<NewGameForm> {
  GridLevel level = GridLevel.beginner;

  @override
  Widget build(BuildContext context) {
    /// hack to sync timerBloc in other pages
    TimerBloc timerBloc = context.read<TimerBloc>();
    NavBloc navBloc = context.read<NavBloc>();
    GridBloc gridBloc = context.read<GridBloc>();

    bool canResumeGame =
        context.select((GridBloc bloc) => (bloc.state.isInEdition));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectorView(
            list: [
              'Debutant',
              'Facile',
              'Moyen',
              'Difficile',
              'Avance',
              'Expert',
            ],
            onSelect: (int index) {
              setState(() {
                level = GridLevels[index];
              });
            },
          ),
          if (canResumeGame)
            OutlinedButton(
              onPressed: () {
                navBloc.add(NavigateEvent(screenKey: NavGridPage.pageKey));
              },
              child: Text(
                'Continuer',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(Size(70.w, 40)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          OutlinedButton(
            onPressed: () {
              gridBloc.add(GridBuildEvent(level));
              navBloc.add(NavigateEvent(screenKey: NavGridPage.pageKey));
            },
            child: Text(
              'Nouvelle partie',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(Size(70.w, 40)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
