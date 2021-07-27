import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/navigation/bloc/nav_bloc.dart';

class MyNavigator extends StatelessWidget {
  const MyNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        final NavBloc navBloc = context.read<NavBloc>();
        return Navigator(
          pages: state.screens,
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }
            navBloc.add(GoBackEvent());
            return true;
          },
        );
      },
    );
  }
}
