part of 'grid_repo_bloc.dart';

abstract class GridRepoState extends Equatable {
  final List<Box> boxList;
  const GridRepoState({required this.boxList});

  @override
  List<Object> get props => [boxList];
}

class GridRepoInitial extends GridRepoState {
  static List<Box> initialBoxList() {
    return List<Box>.filled(Grid.length, Box.disable(soluce: Symbol.none()));
  }

  const GridRepoInitial(List<Box> boxList) : super(boxList: boxList);
}

class GridRepoRunning extends GridRepoState {
  const GridRepoRunning(List<Box> boxList) : super(boxList: boxList);
}

class GridRepoComplete extends GridRepoState {
  const GridRepoComplete(List<Box> boxList) : super(boxList: boxList);
}
