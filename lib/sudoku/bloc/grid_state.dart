part of 'grid_bloc.dart';

abstract class GridState extends Equatable {
  final List<Box> boxList;
  final bool annotations;

  const GridState({
    required this.boxList,
    required this.annotations,
  });

  @override
  List<Object> get props => [boxList, annotations];
}

class GridInitial extends GridState {
  static List<Box> initialBoxList() {
    return List<Box>.filled(
      Grid.length,
      Box.disable(soluce: Symbol.none()),
    );
  }

  const GridInitial({
    required List<Box> boxList,
  }) : super(boxList: boxList, annotations: false);
}

class GridCreation extends GridState {
  const GridCreation({
    required List<Box> boxList,
  }) : super(boxList: boxList, annotations: false);
}

class GridEditable extends GridState {
  const GridEditable({
    required List<Box> boxList,
    required bool annotations,
  }) : super(boxList: boxList, annotations: annotations);
}

class GridLocked extends GridState {
  const GridLocked({
    required List<Box> boxList,
    required bool annotations,
  }) : super(boxList: boxList, annotations: annotations);
}

class GridComplete extends GridState {
  const GridComplete({
    required List<Box> boxList,
    required bool annotations,
  }) : super(boxList: boxList, annotations: annotations);
}
