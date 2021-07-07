part of 'grid_bloc.dart';

class GridEvent extends Equatable {
  final GridBuildState state;
  const GridEvent({required this.state});

  @override
  List<Object> get props => [state];
}
