part of 'grid_bloc.dart';

enum GridStatus { initial, inCreation, inEdition, complete }

class GridState extends Equatable {
  final List<Box> boxList;
  final bool annotation;
  final bool soluce;
  final GridStatus status;

  bool get isInitial => status == GridStatus.initial;
  bool get isInCreation => status == GridStatus.inCreation;
  bool get isInEdition => status == GridStatus.inEdition;
  bool get isComplete => status == GridStatus.complete;

  const GridState({
    required this.boxList,
    required this.annotation,
    required this.soluce,
    required this.status,
  });

  const GridState.initial(List<Box> boxList)
      : this(
          boxList: boxList,
          annotation: false,
          soluce: false,
          status: GridStatus.initial,
        );

  const GridState.inCreation(List<Box> boxList)
      : this(
          boxList: boxList,
          annotation: false,
          soluce: false,
          status: GridStatus.inCreation,
        );

  const GridState.inEdition({
    required List<Box> boxList,
    required bool annotation,
    required bool soluce,
  }) : this(
          boxList: boxList,
          annotation: annotation,
          soluce: soluce,
          status: GridStatus.inEdition,
        );

  const GridState.complete(List<Box> boxList)
      : this(
          boxList: boxList,
          annotation: false,
          soluce: false,
          status: GridStatus.complete,
        );

  factory GridState.fromJson(Map<String, dynamic> json) {
    return GridState(
      boxList: json['boxList'] as List<Box>,
      annotation: json['annotation'] as bool,
      soluce: json['soluce'] as bool,
      status: json['status'] as GridStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boxList': boxList.map((Box box) => box.toJson()),
      'annotation': annotation,
      'soluce': soluce,
      'status': status,
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
  }) {
    return GridState(
      boxList: boxList ?? this.boxList,
      annotation: annotation ?? this.annotation,
      soluce: soluce ?? this.soluce,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [boxList, annotation, soluce, status];
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
