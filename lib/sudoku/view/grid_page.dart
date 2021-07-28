import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/bloc/timer_bloc.dart';
import 'package:sudoku/sudoku/view/action_bar.dart';
import 'package:sudoku/sudoku/view/grid_view.dart';
import 'package:sudoku/sudoku/view/new_game_form.dart';
import 'package:sudoku/sudoku/view/symbol_bar.dart';
import 'package:sizer/sizer.dart';

class GridPage extends StatelessWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool shouldShowEditableSection =
        !context.select((GridBloc gridBloc) => gridBloc.state is GridComplete);
    bool shouldShowPlayAgainSection =
        context.select((GridBloc gridBloc) => gridBloc.state is GridComplete);

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TimerBloc, TimerState>(
          builder: (context, state) {
            String seconds = (state.duration % 60).toString().padLeft(2, '0');
            String minutes = (state.duration ~/ 60).toString().padLeft(2, '0');
            return Text("$minutes : $seconds");
          },
        ),
        centerTitle: true,
        actions: [TimerPlayPauseButton()],
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GridWidget(),
          SizedBox(height: 2.h),
          if (shouldShowEditableSection) EditionSection(),
          if (shouldShowPlayAgainSection) PlayAgainSection(),
        ],
      ),
    );
  }
}

class PlayAgainSection extends StatelessWidget {
  const PlayAgainSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 2.h),
        NewGameForm(),
      ],
    );
  }
}

class EditionSection extends StatelessWidget {
  const EditionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SymbolBar(),
        SizedBox(height: 2.h),
        ActionBar(),
        WinDialog(),
      ],
    );
  }
}

class WinDialog extends StatelessWidget {
  const WinDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<GridBloc, GridState>(
      listener: (context, state) {
        if (state is GridComplete) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Victoire 🏆'),
              content: const Text('Bravo vous avez validé la grille'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('YESSS  💪'),
                ),
              ],
            ),
          );
        }
      },
      child: Container(),
    );
  }
}

class TimerPlayPauseButton extends StatelessWidget {
  const TimerPlayPauseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        TimerBloc timerBloc = context.read<TimerBloc>();
        return IconButton(
          onPressed: timerBloc.enable ? timerBloc.onPressPlayPause : null,
          icon: (state is TimerRunning)
              ? Icon(Icons.pause)
              : Icon(
                  Icons.play_arrow,
                  color: timerBloc.enable ? Colors.blue : null,
                ),
        );
      },
    );
  }
}
