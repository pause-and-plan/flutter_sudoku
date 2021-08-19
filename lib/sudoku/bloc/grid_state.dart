part of 'grid_bloc.dart';

enum GridStatus { initial, inCreation, inEdition, complete }

class GridState extends Equatable {
  final List<Box> boxList;
  final bool annotation;
  final bool soluce;
  final GridStatus status;
  final int currBoxIndex;

  bool get isInitial => status == GridStatus.initial;
  bool get isInCreation => status == GridStatus.inCreation;
  bool get isInEdition => status == GridStatus.inEdition;
  bool get isComplete => status == GridStatus.complete;
  Box get currBox => boxList[currBoxIndex];

  const GridState(
      {required this.boxList,
      required this.annotation,
      required this.soluce,
      required this.status,
      required this.currBoxIndex});

  const GridState.initial(List<Box> boxList)
      : this(
          boxList: boxList,
          annotation: false,
          soluce: false,
          status: GridStatus.initial,
          currBoxIndex: 0,
        );

  const GridState.inCreation(List<Box> boxList)
      : this(
          boxList: boxList,
          annotation: false,
          soluce: false,
          status: GridStatus.inCreation,
          currBoxIndex: 0,
        );

  const GridState.inEdition({
    required List<Box> boxList,
    required bool annotation,
    required bool soluce,
    required int currBoxIndex,
  }) : this(
          boxList: boxList,
          annotation: annotation,
          soluce: soluce,
          status: GridStatus.inEdition,
          currBoxIndex: currBoxIndex,
        );

  const GridState.complete({
    required List<Box> boxList,
    required int currBoxIndex,
  }) : this(
          boxList: boxList,
          annotation: false,
          soluce: false,
          status: GridStatus.complete,
          currBoxIndex: currBoxIndex,
        );

  factory GridState.fromJson(Map<String, dynamic> json) {
    return GridState(
      boxList: (json['boxList'] as List).map((e) => Box.fromJson(e)).toList(),
      annotation: json['annotation'] as bool,
      soluce: json['soluce'] as bool,
      status: EnumToString.fromString(GridStatus.values, json['status'])
          as GridStatus,
      currBoxIndex:
          json['currBoxIndex'] != null ? json['currBoxIndex'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boxList': boxList.map((Box box) => box.toJson()).toList(),
      'annotation': annotation,
      'soluce': soluce,
      'status': EnumToString.convertToString(status),
      'currBoxIndex': currBoxIndex,
    };
  }

  static List<Box> initialBoxList() {
    return List<Box>.filled(
      Grid.length,
      Box.disable(soluce: Symbol.none()),
    );
  }

  GridState copyWith({
    List<Box>? boxList,
    bool? annotation,
    bool? soluce,
    GridStatus? status,
    int? currBoxIndex,
  }) {
    return GridState(
      boxList: boxList ?? this.boxList,
      annotation: annotation ?? this.annotation,
      soluce: soluce ?? this.soluce,
      status: status ?? this.status,
      currBoxIndex: currBoxIndex ?? this.currBoxIndex,
    );
  }

  List<Box> replaceBox(Box box) {
    List<Box> nextList = [...boxList];
    nextList[currBoxIndex] = box;
    return nextList;
  }

  @override
  List<Object> get props => [boxList, annotation, soluce, status, currBoxIndex];
}

// class GridInitial extends GridState {
//   static List<Box> initialBoxList() {
//     return List<Box>.filled(
//       Grid.length,
//       Box.disable(soluce: Symbol.none()),
//     );
//   }

//   const GridInitial({
//     required List<Box> boxList,
//   }) : super(boxList: boxList, annotation: false, soluce: false);

//   static fromJson(Map<String, dynamic> json) {
//     return GridInitial(
//       boxList: json['boxList'] as List<Box>,
//     );
//   }
// }

// class GridCreation extends GridState {
//   const GridCreation({
//     required List<Box> boxList,
//   }) : super(boxList: boxList, annotation: false, soluce: false);

//   static fromJson(Map<String, dynamic> json) {
//     return GridCreation(
//       boxList: json['boxList'] as List<Box>,
//     );
//   }
// }

// class GridEditable extends GridState {
//   const GridEditable({
//     required List<Box> boxList,
//     required bool annotation,
//     required bool soluce,
//   }) : super(boxList: boxList, annotation: annotation, soluce: soluce);

//   GridEditable copyWith({
//     List<Box>? boxList,
//     bool? annotation,
//     bool? soluce,
//   }) {
//     return GridEditable(
//       boxList: boxList ?? this.boxList,
//       annotation: annotation ?? this.annotation,
//       soluce: soluce ?? this.soluce,
//     );
//   }

//   static fromJson(Map<String, dynamic> json) {
//     return GridEditable(
//       boxList: json['boxList'] as List<Box>,
//       annotation: json['annotation'] as bool,
//       soluce: json['soluce'] as bool,
//     );
//   }
// }

// class GridComplete extends GridState {
//   const GridComplete({
//     required List<Box> boxList,
//     required bool annotation,
//   }) : super(boxList: boxList, annotation: annotation, soluce: false);

//   static fromJson(Map<String, dynamic> json) {
//     return GridComplete(
//       boxList: json['boxList'] as List<Box>,
//       annotation: json['annotation'] as bool,
//     );
//   }
// }
