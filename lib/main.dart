import 'package:flutter/material.dart';
import 'package:sudoku/presenter/game.dart';
import 'package:sudoku/presenter/timerPresenter.dart';
import 'view/HomePage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GamePresenter.reset()),
        ChangeNotifierProvider(create: (context) => MyTimer()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        buttonTheme: ButtonThemeData(buttonColor: Colors.black12),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black12,
        ),
        iconTheme: IconThemeData(color: Colors.black54),
      ),
      home: Consumer<GamePresenter>(
        builder: (context, game, child) => Consumer<MyTimer>(
          builder: (context, timer, child) =>
              HomePage(game: game, timer: timer),
        ),
      ),
    );
  }
}
