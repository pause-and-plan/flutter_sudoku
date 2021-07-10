part of 'grid_provider_bloc.dart';

abstract class GridProviderEvent extends Equatable {
  const GridProviderEvent();
  @override
  List<Object> get props => [];
}

class GridProviderStartEvent extends GridProviderEvent {
  final GridLevel level;
  const GridProviderStartEvent({required this.level}) : super();

  @override
  List<Object> get props => [level];
}

class GridProviderRunningEvent extends GridProviderEvent {
  final List<BoxPuzzled> boxList;
  final GridProviderStep step;
  final int stepPercent;

  const GridProviderRunningEvent({
    required this.boxList,
    required this.step,
    required this.stepPercent,
  }) : super();

  @override
  List<Object> get props => [...boxList, step, stepPercent];
}

class GridProviderCompleteEvent extends GridProviderEvent {
  final List<BoxPuzzled> boxList;
  final GridProviderStep step;

  const GridProviderCompleteEvent({
    required this.boxList,
    required this.step,
  }) : super();

  @override
  List<Object> get props => [...boxList, step];
}
