part of 'grid_puzzler_bloc.dart';

abstract class GridPuzzlerEvent extends Equatable {
  const GridPuzzlerEvent();

  @override
  List<Object> get props => [];
}

class GridPuzzlerStartEvent extends GridPuzzlerEvent {
  final List<BoxPuzzled> boxList;
  final GridLevel level;

  const GridPuzzlerStartEvent({
    required this.boxList,
    this.level = GridLevel.easy,
  }) : super();

  @override
  List<Object> get props => [boxList, level];
}
