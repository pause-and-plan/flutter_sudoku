import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/constants.dart';
import 'package:sudoku/presenter/game.dart';

class Symbol extends StatelessWidget {
  final String text;
  final bool bold;
  const Symbol({
    Key? key,
    required this.text,
    this.bold = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: bold ? Colors.black87 : Colors.black54,
            fontFamily: 'Signifika',
          ),
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  final int index;
  const Box({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 20;
    if (width > 500) width = 500;
    double size = (width - 30 - 18 - 6) / 9;

    return Consumer<GamePresenter>(
      builder: (context, game, child) => InkWell(
        onTap: () => game.changeCurrentBoxIndex(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
            color: game.currentBoxIndex == index
                ? Colors.black12
                : Colors.transparent,
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Symbol(
                text: game.getSymbol(index), bold: game.isBoxEditable(index)),
          ),
        ),
      ),
    );
  }
}

class GridSection extends StatelessWidget {
  const GridSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final noborder = Border.all(width: 0, color: Colors.transparent);

    double size = MediaQuery.of(context).size.width - 20;
    if (size > 500) size = 500;
    double interval = (size) / 3;
    return Container(
      width: size,
      height: size,
      child: GridPaper(
        color: Colors.black54,
        divisions: 1,
        subdivisions: 1,
        interval: interval,
        child: GridView.count(
          crossAxisCount: 9,
          children: List.generate(
            GRID_LENGTH,
            (index) => Box(index: index),
          ),
        ),
      ),
      // child: Column(
      //   children: [
      //     Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //       Block(border: noborder),
      //       Block(
      //         border: Border.symmetric(
      //           vertical: BorderSide(width: 2, color: Colors.black),
      //         ),
      //       ),
      //       Block(border: noborder),
      //     ]),
      //     Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //       Block(
      //         border: Border.symmetric(
      //           horizontal: BorderSide(width: 2, color: Colors.black),
      //         ),
      //       ),
      //       Block(
      //         border: Border.all(width: 2, color: Colors.black),
      //       ),
      //       Block(
      //         border: Border.symmetric(
      //           horizontal: BorderSide(width: 2, color: Colors.black),
      //         ),
      //       ),
      //     ]),
      //     Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //       Block(border: noborder),
      //       Block(
      //         border: Border.symmetric(
      //           vertical: BorderSide(width: 2, color: Colors.black),
      //         ),
      //       ),
      //       Block(border: noborder),
      //     ]),
      //   ],
      // ),
    );
  }
}
