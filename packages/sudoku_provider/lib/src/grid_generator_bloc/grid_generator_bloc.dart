import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../helpers/grid_validator.dart';
import '../helpers/grid.dart';
import '../models/box_model.dart';
import '../models/symbol_model.dart';

part 'grid_generator_event.dart';
part 'grid_generator_state.dart';

class GridGeneratorBloc extends Bloc<GridGeneratorEvent, GridGeneratorState> {
  late List<BoxPuzzled> boxList;
  late int _index;
  int _progression = 0;

  BoxPuzzled get _currBox => boxList[_index];

  GridGeneratorBloc() : super(GridGeneratorInitial());

  @override
  Stream<GridGeneratorState> mapEventToState(
    GridGeneratorEvent event,
  ) async* {
    if (event is GridGeneratorStartEvent) {
      yield* _startEventToState();
    }
  }

  Stream<GridGeneratorState> _startEventToState() async* {
    _initializeGrid();
    while (0 <= _index && _index < Grid.length) {
      _progression = (_index + 1) ~/ Grid.length;
      _tryResolveCurrBox();
      yield GridGeneratorRunning(boxList: boxList, progression: _progression);
    }
    yield GridGeneratorComplete(boxList: boxList);
  }

  _initializeGrid() {
    boxList = List.generate(Grid.length, (_) => BoxPuzzled.unordered());
    _index = 0;
    _progression = 0;
  }

  _tryResolveCurrBox() {
    try {
      _resolveCurrBox();
      _index++;
    } catch (error) {
      // print(error);
      boxList[_index] = BoxPuzzled.unordered();
      _index--;
    }
  }

  void _resolveCurrBox() {
    while (_currBox.availableSymbols.isNotEmpty) {
      Symbol symbol = _currBox.pickAvailableSymbol();
      if (_canSetBoxSymbol(symbol)) {
        boxList[_index].symbol = symbol;
        return;
      }
    }
    throw ('No one available symbol can be set at this index');
  }

  bool _canSetBoxSymbol(Symbol symbol) {
    GridValidator validator = GridValidator.fromBoxList(boxList: boxList);
    return validator.isSymbolValidAtIndex(symbol, _index);
  }
}
