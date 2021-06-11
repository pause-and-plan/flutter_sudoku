import 'package:flutter/material.dart';
import 'sudokuScreen.dart';

void main() {
  runApp(MyApp());
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
        home: SudokuScreen());
  }
}
