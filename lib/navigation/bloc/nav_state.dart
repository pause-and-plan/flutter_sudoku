part of 'nav_bloc.dart';

abstract class NavState extends Equatable {
  final ValueKey key;
  final List<NavState> stack;
  final Widget view;

  const NavState({required this.stack, required this.view, required this.key});

  List<Page<dynamic>> get screens {
    List<Page<dynamic>> listOfScreen = stack
        .map((NavState screen) =>
            MaterialPage(key: screen.key, child: screen.view))
        .toList();
    listOfScreen.add(MaterialPage(key: key, child: view));
    return listOfScreen;
  }

  @override
  List<Object> get props => [key, stack, view];
}

class NavHomePage extends NavState {
  static const pageKey = const ValueKey('HomePage');
  NavHomePage() : super(stack: [], view: HomePage(), key: NavHomePage.pageKey);
}

class NavGridPage extends NavState {
  static const pageKey = const ValueKey('GridPage');
  NavGridPage(List<NavState> stack)
      : super(stack: stack, view: GridPage(), key: NavGridPage.pageKey);
}
