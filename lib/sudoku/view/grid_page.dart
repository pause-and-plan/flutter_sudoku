import 'dart:math';

import 'package:confetti/confetti.dart';
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
        !context.select((GridBloc gridBloc) => gridBloc.state.isComplete);
    bool shouldShowPlayAgainSection =
        context.select((GridBloc gridBloc) => gridBloc.state.isComplete);

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

class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({Key? key}) : super(key: key);

  @override
  _ConfettiAnimationState createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
            createParticlePath: drawStar, // define a custom shape/path.
          ),
        ),
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
        if (state.isComplete) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Victoire 🏆'),
              content: const Text('Bravo vous avez validé la grille'),
              actions: <Widget>[
                ConfettiAnimation(),
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
          icon: (state.isRunning)
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
