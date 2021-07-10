part of 'grid_provider_bloc.dart';

abstract class GridProviderState extends Equatable {
  final List<BoxPuzzled> boxList;
  const GridProviderState({required this.boxList});

  @override
  List<Object> get props => [...boxList];
}

class GridProviderInitial extends GridProviderState {
  GridProviderInitial() : super(boxList: Grid.list);
}

enum GridProviderStep { fill, puzzle }

class GridProviderRunning extends GridProviderState {
  final GridProviderStep step;
  final int stepPercent;
  GridProviderRunning({
    required List<BoxPuzzled> boxList,
    required this.step,
    required this.stepPercent,
  }) : super(boxList: boxList);
}

class GridProviderComplete extends GridProviderState {
  final GridProviderStep step;

  GridProviderComplete({
    required List<BoxPuzzled> boxList,
    required this.step,
  }) : super(boxList: boxList);
}
