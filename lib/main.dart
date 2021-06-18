import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/state/app_state.dart';
import 'view/HomePage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
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
      home: HomePage(),
    );
  }
}
