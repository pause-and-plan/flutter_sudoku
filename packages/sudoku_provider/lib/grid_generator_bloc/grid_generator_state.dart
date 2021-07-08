part of 'grid_generator_bloc.dart';

abstract class GridGeneratorState extends Equatable {
  final List<BoxGenerator> boxList;
  const GridGeneratorState({required this.boxList});

  @override
  List<Object> get props => [...boxList];
}

class GridGeneratorInitial extends GridGeneratorState {
  GridGeneratorInitial()
      : super(
          boxList: List.generate(Grid.length, (_) => BoxGenerator.unordered()),
        );
}

class GridGeneratorRunning extends GridGeneratorState {
  GridGeneratorRunning({required List<BoxGenerator> boxList})
      : super(boxList: boxList);
}

class GridGeneratorComplete extends GridGeneratorState {
  GridGeneratorComplete({required List<BoxGenerator> boxList})
      : super(boxList: boxList);
}
