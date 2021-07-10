part of 'grid_generator_bloc.dart';

abstract class GridGeneratorState extends Equatable {
  final List<BoxPuzzled> boxList;
  const GridGeneratorState({required this.boxList});

  @override
  List<Object> get props => [...boxList];
}

class GridGeneratorInitial extends GridGeneratorState {
  GridGeneratorInitial()
      : super(
          boxList: List.generate(Grid.length, (_) => BoxPuzzled.unordered()),
        );
}

class GridGeneratorRunning extends GridGeneratorState {
  final int progression;

  GridGeneratorRunning(
      {required List<BoxPuzzled> boxList, required this.progression})
      : super(boxList: boxList);
}

class GridGeneratorComplete extends GridGeneratorState {
  GridGeneratorComplete({required List<BoxPuzzled> boxList})
      : super(boxList: boxList);
}
