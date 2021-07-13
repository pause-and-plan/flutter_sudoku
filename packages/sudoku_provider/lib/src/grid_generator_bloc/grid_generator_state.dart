part of 'grid_generator_bloc.dart';

abstract class GridGeneratorState extends Equatable {
  static unorderedBoxList() {
    return List.generate(Grid.length, (_) => BoxPuzzled.unordered());
  }

  final List<BoxPuzzled> boxList;
  const GridGeneratorState({required this.boxList});

  @override
  List<Object> get props => [boxList];
}

class GridGeneratorInitial extends GridGeneratorState {
  GridGeneratorInitial()
      : super(boxList: GridGeneratorState.unorderedBoxList());
}

class GridGeneratorRunning extends GridGeneratorState {
  final int progression;

  const GridGeneratorRunning(
      {required List<BoxPuzzled> boxList, required this.progression})
      : super(boxList: boxList);

  @override
  List<Object> get props => [boxList, progression];
}

class GridGeneratorComplete extends GridGeneratorState {
  const GridGeneratorComplete({required List<BoxPuzzled> boxList})
      : super(boxList: boxList);
}
