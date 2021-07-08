part of 'grid_generator_bloc.dart';

abstract class GridGeneratorEvent extends Equatable {
  const GridGeneratorEvent();

  @override
  List<Object> get props => [];
}

class GenerateGridEvent extends GridGeneratorEvent {}
