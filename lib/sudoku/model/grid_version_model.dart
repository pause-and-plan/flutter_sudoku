import 'package:equatable/equatable.dart';
import 'package:sudoku/sudoku/model/box_model.dart';

class GridVersion extends Equatable {
  final List<Box> boxList;
  final int index;
  const GridVersion({required this.boxList, required this.index});

  @override
  List<Object> get props => [boxList, index];
}
