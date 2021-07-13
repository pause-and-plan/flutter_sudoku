part of 'grid_bloc.dart';

abstract class GridEvent extends Equatable {
  const GridEvent();

  @override
  List<Object> get props => [];
}

class GridBuildEvent extends GridEvent {
  final GridLevel level;
  GridBuildEvent(this.level);

  @override
  List<Object> get props => [level];
}

class GridBuildingEvent extends GridEvent {
  final GridRepoState state;
  GridBuildingEvent(this.state);

  @override
  List<Object> get props => [state];
}

class GridPressBoxEvent extends GridEvent {
  final int index;
  GridPressBoxEvent(this.index);

  @override
  List<Object> get props => [index];
}

class GridPressSymbolEvent extends GridEvent {
  final Symbol symbol;
  const GridPressSymbolEvent(this.symbol) : super();

  @override
  List<Object> get props => [symbol];
}

class GridPressEraseEvent extends GridEvent {
  const GridPressEraseEvent() : super();
}

class GridPressCheckEvent extends GridEvent {
  const GridPressCheckEvent() : super();
}

class GridPressAnnotationEvent extends GridEvent {
  const GridPressAnnotationEvent() : super();
}

class GridLockEvent extends GridEvent {
  const GridLockEvent() : super();
}

class GridUnlockEvent extends GridEvent {
  const GridUnlockEvent() : super();
}

class GridResetEvent extends GridEvent {
  const GridResetEvent() : super();
}

class GridUndoEvent extends GridEvent {
  const GridUndoEvent() : super();
}
