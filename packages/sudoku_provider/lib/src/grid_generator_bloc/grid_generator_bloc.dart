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
  List<BoxPuzzled> _boxList = GridGeneratorState.unorderedBoxList();
  late int _index;
  int _progression = 0;

  BoxPuzzled get _currBox => _boxList[_index];
  set _currBox(BoxPuzzled box) {
    List<BoxPuzzled> nextBoxList = [..._boxList];
    nextBoxList[_index] = box;
    _boxList = nextBoxList;
  }

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
      await Future.delayed(Duration(milliseconds: 0));
      _progression = (_index + 1) ~/ Grid.length;
      _tryResolveCurrBox();
      yield GridGeneratorRunning(boxList: _boxList, progression: _progression);
    }
    yield GridGeneratorComplete(boxList: _boxList);
  }

  _initializeGrid() {
    _boxList = List.generate(Grid.length, (_) => BoxPuzzled.unordered());
    _index = 0;
    _progression = 0;
  }

  _tryResolveCurrBox() {
    try {
      _resolveCurrBox();
      _index++;
    } catch (error) {
      // print(error);
      _currBox = BoxPuzzled.unordered();
      _index--;
    }
  }

  void _resolveCurrBox() {
    while (_currBox.availableSymbols.isNotEmpty) {
      Symbol symbol = _currBox.getFirstAvailableSymbol();
      if (_canSetBoxSymbol(symbol)) {
        _currBox = _currBox.copyWithSymbol(symbol);
        return;
      } else {
        _currBox = _currBox.copyWithoutAvailableSymbol(symbol);
      }
    }
    throw ('No one available symbol can be set at this index');
  }

  bool _canSetBoxSymbol(Symbol symbol) {
    GridValidator validator = GridValidator.fromBoxList(boxList: _boxList);
    return validator.isSymbolValidAtIndex(symbol, _index);
  }
}
