import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/sudoku/bloc/timer_bloc.dart';
import 'package:sudoku/sudoku/view/action_bar.dart';
import 'package:sudoku/sudoku/view/grid_view.dart';
import 'package:sudoku/sudoku/view/symbol_bar.dart';
import 'package:sizer/sizer.dart';

class GridPage extends StatelessWidget {
  const GridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          SymbolBar(),
          SizedBox(height: 2.h),
          ActionBar(),
        ],
      ),
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
          onPressed: timerBloc.onPressPlayPause,
          icon: (state is TimerRunning)
              ? Icon(Icons.pause)
              : Icon(Icons.play_arrow, color: Colors.blue),
        );
      },
    );
  }
}
