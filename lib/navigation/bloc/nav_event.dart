part of 'nav_bloc.dart';

abstract class NavEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GoBackEvent extends NavEvent {
  GoBackEvent() : super();
}

class NavigateEvent extends NavEvent {
  final ValueKey screenKey;
  NavigateEvent({required this.screenKey});

  @override
  List<Object> get props => [screenKey];
}
