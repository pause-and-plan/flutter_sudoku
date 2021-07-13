part of 'grid_puzzler_bloc.dart';

abstract class GridPuzzlerState extends Equatable {
  final List<BoxPuzzled> boxList;
  const GridPuzzlerState({required this.boxList});

  @override
  List<Object> get props => [...boxList];

  static disableList(List<BoxPuzzled> boxList) {
    return boxList.map((e) => BoxPuzzled.disable(symbol: e.symbol)).toList();
  }
}

class GridPuzzlerInitial extends GridPuzzlerState {
  GridPuzzlerInitial()
      : super(
          boxList: List.generate(Grid.length,
              (index) => BoxPuzzled.disable(symbol: Symbol.none())),
        );
}

class GridPuzzlerRunning extends GridPuzzlerState {
  final int progression;

  GridPuzzlerRunning(
      {required List<BoxPuzzled> boxList, required this.progression})
      : super(boxList: boxList);
}

class GridPuzzlerComplete extends GridPuzzlerState {
  GridPuzzlerComplete({required List<BoxPuzzled> boxList})
      : super(boxList: boxList);
}
