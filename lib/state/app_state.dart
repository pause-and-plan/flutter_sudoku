import 'package:flutter/material.dart';
import 'package:sudoku/constants.dart';
import 'package:sudoku/grid_generator/grid_generator.dart';
import 'package:sudoku/state/grid_state.dart';
import 'package:sudoku/state/timer_state.dart';

class AppState extends ChangeNotifier {
  Grid grid = Grid.empty();
  late MyTimer timer;

  AppState() {
    createNewGrid();
  }

  void createNewGrid([GridLevel level = GridLevel.easy]) {
    List<Box> listOfBox = _buildListOfBox(level);
    grid = Grid(listOfBox, level);
    timer = MyTimer(notifyListeners);
    notifyListeners();
  }

  void onPressResetGrid() {
    timer.reset();
    grid.reset();
    notifyListeners();
  }

  void onPressGlobalCheck() {
    grid.toggleGlobalCheck();
    notifyListeners();
  }

  void onToggleTimer() {
    if (timer.status == TimerStatus.running) {
      timer.pause();
      grid.lock();
    } else {
      timer.play();
      grid.unlock();
    }
    notifyListeners();
  }

  void onPressBox(int index) {
    bool shouldRemoveBoxFocus = grid.boxIndex == index;
    if (shouldRemoveBoxFocus) {
      grid.removeBoxFocus();
      notifyListeners();
    } else if (grid.canFocusBox(index)) {
      grid.focusBox(index);
      notifyListeners();
    }
  }

  void onPressSymbol(int symbol) {
    if (grid.canApplyChangeOnFocusedBox()) {
      if (grid.currentBox.annotationsEnable) {
        grid.toggleAnnotationSymbolOnFocusedBox(symbol - 1);
      } else {
        grid.toggleSymbolOnFocusedBox(symbol);
      }
      notifyListeners();
    }
  }

  void onPressUndo() {
    grid.previous();
    notifyListeners();
  }

  void onPressBoxCheck() {
    if (grid.canApplyChangeOnFocusedBox()) {
      grid.toggleCheckOnFocusedBox();
      notifyListeners();
    }
  }

  void onPressBoxSoluce() {
    if (grid.canApplyChangeOnFocusedBox()) {
      grid.applySoluceOnFocusedBox();
      notifyListeners();
    }
  }

  void onPressBoxAnnotation() {
    if (grid.canApplyChangeOnFocusedBox()) {
      grid.toggleAnnotationOnFocusedBox();
      notifyListeners();
    }
  }

  void onPressBoxReset() {
    if (grid.canApplyChangeOnFocusedBox()) {
      grid.currentBox.reset();
      notifyListeners();
    }
  }

  List<Box> _buildListOfBox(GridLevel level) {
    GridGenerator generator = GridGenerator();
    generator.newGrid(level, _onChangeGridGeneratorStatus);
    List<Box> listOfBox = List.generate(GRID_LENGTH, (index) {
      int soluceSymbol = generator.filledGrid[index].symbol;
      bool editable = generator.puzzleGrid[index].editable;
      return Box(soluceSymbol, editable);
    });
    return listOfBox;
  }

  void _onChangeGridGeneratorStatus(
    GridGeneratorStatus status,
    double progressInPercent,
  ) {
    if (status == GridGeneratorStatus.inProgress) {
      grid.status = GridStatus.loading;
    } else if (status == GridGeneratorStatus.finished) {
      grid.status = GridStatus.ready;
    }
    grid.loadingPercent = progressInPercent;
    notifyListeners();
  }
}
