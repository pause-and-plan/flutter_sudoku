part of 'grid_bloc.dart';

class GridState extends Equatable {
  final GridBuildState state;
  const GridState({required this.state});
  
  @override
  List<Object> get props => [state];
}

class GridInitial extends GridState {
  GridInitial(): super(state: GridBuildState.initial());
}
