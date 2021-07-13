part of 'grid_repo_bloc.dart';

abstract class GridRepoEvent extends Equatable {
  const GridRepoEvent();

  @override
  List<Object> get props => [];
}

class GridRepoStartEvent extends GridRepoEvent {
  final GridLevel level;
  const GridRepoStartEvent({required this.level});

  @override
  List<Object> get props => [level];
}

class GridRepoRunningEvent extends GridRepoEvent {
  final List<BoxPuzzled> boxList;
  const GridRepoRunningEvent({required this.boxList});

  @override
  List<Object> get props => [boxList];
}

class GridRepoCompleteEvent extends GridRepoEvent {
  final List<BoxPuzzled> boxList;
  const GridRepoCompleteEvent({required this.boxList});

  @override
  List<Object> get props => [boxList];
}
