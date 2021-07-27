import 'package:flutter/material.dart';
import 'package:sudoku/sudoku/view/new_game_form.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: EdgeInsets.all(50),
            child: Image(image: AssetImage('assets/logo_white.png')),
          ),
          NewGameForm()
        ]),
      ),
    );
  }
}
