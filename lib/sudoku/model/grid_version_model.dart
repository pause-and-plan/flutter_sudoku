import 'package:equatable/equatable.dart';
import 'package:sudoku/sudoku/model/box_model.dart';

class GridVersion extends Equatable {
  final List<Box> boxList;
  final int index;
  const GridVersion({required this.boxList, required this.index});

  @override
  List<Object> get props => [boxList, index];

  Map toJson() {
    return {
      'boxList': boxList.map((Box box) => box.toJson()),
      'index': index,
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return GridVersion(
      boxList: json['boxList'] as List<Box>,
      index: json['index'] as int,
    );
  }
}
