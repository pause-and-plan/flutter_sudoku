part of 'grid_bloc.dart';

abstract class GridState extends Equatable {
  final List<Box> boxList;
  final bool annotation;
  final bool soluce;

  const GridState({
    required this.boxList,
    required this.annotation,
    required this.soluce,
  });

  @override
  List<Object> get props => [boxList, annotation, soluce];
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
  }) : super(boxList: boxList, annotation: false, soluce: false);
}

class GridCreation extends GridState {
  const GridCreation({
    required List<Box> boxList,
  }) : super(boxList: boxList, annotation: false, soluce: false);
}

class GridEditable extends GridState {
  const GridEditable({
    required List<Box> boxList,
    required bool annotation,
    required bool soluce,
  }) : super(boxList: boxList, annotation: annotation, soluce: soluce);

  GridEditable copyWith({
    List<Box>? boxList,
    bool? annotation,
    bool? soluce,
  }) {
    return GridEditable(
      boxList: boxList ?? this.boxList,
      annotation: annotation ?? this.annotation,
      soluce: soluce ?? this.soluce,
    );
  }
}

class GridComplete extends GridState {
  const GridComplete({
    required List<Box> boxList,
    required bool annotation,
  }) : super(boxList: boxList, annotation: annotation, soluce: false);
}
