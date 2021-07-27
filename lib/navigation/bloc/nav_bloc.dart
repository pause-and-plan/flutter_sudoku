import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sudoku/home/home_page.dart';
import 'package:sudoku/sudoku/view/grid_page.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavHomePage());

  @override
  Stream<NavState> mapEventToState(
    NavEvent event,
  ) async* {
    if (event is NavigateEvent) {
      yield* _navigateEventToState(event);
    } else if (event is GoBackEvent) {
      yield* _goBackEventToState();
    }
  }

  Stream<NavState> _goBackEventToState() async* {
    if (state.stack.isNotEmpty) {
      yield state.stack.last;
    }
  }

  Stream<NavState> _navigateEventToState(NavigateEvent event) async* {
    if (event.screenKey == NavHomePage.pageKey) {
      yield NavHomePage();
    } else if (event.screenKey == NavGridPage.pageKey) {
      yield NavGridPage([...state.stack, state]);
    }
  }
}
