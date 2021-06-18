import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/state/app_state.dart';
import 'package:sudoku/view/widgets/grid/Annotation.dart';

class Symbol extends StatelessWidget {
  final String text;
  final Color color;
  const Symbol({
    Key? key,
    required this.text,
    required this.color,
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
            color: color,
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
    double size = (width - 30) / 9;

    return Consumer<AppState>(
      builder: (context, state, child) => InkWell(
        onTap: () => state.onPressBox(index),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
            color: state.grid.boxIndex == index
                ? Colors.black12
                : Colors.transparent,
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: state.grid.shouldShowBoxAnnotation(index)
                ? Annotations(list: state.grid.getListOfAnnotation(index))
                : Symbol(
                    text: state.grid.getSymbol(index),
                    color: state.grid.getSymbolColor(index),
                  ),
          ),
        ),
      ),
    );
  }
}

class Block extends StatelessWidget {
  final BoxBorder border;
  final int blockX;
  final int blockY;
  const Block({
    required this.border,
    required this.blockX,
    required this.blockY,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: border),
      child: Column(
        children: [
          Row(children: [
            Box(index: (blockY * 3 * 9) + (blockX * 3) + 0),
            Box(index: (blockY * 3 * 9) + (blockX * 3) + 1),
            Box(index: (blockY * 3 * 9) + (blockX * 3) + 2),
          ]),
          Row(children: [
            Box(index: (((blockY * 3) + 1) * 9) + (blockX * 3) + 0),
            Box(index: (((blockY * 3) + 1) * 9) + (blockX * 3) + 1),
            Box(index: (((blockY * 3) + 1) * 9) + (blockX * 3) + 2),
          ]),
          Row(children: [
            Box(index: (((blockY * 3) + 2) * 9) + (blockX * 3) + 0),
            Box(index: (((blockY * 3) + 2) * 9) + (blockX * 3) + 1),
            Box(index: (((blockY * 3) + 2) * 9) + (blockX * 3) + 2),
          ]),
        ],
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
    return Container(
      width: size,
      height: size,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Block(border: noborder, blockY: 0, blockX: 0),
            Block(
              border: Border.symmetric(
                vertical: BorderSide(width: 2, color: Colors.black),
              ),
              blockY: 0,
              blockX: 1,
            ),
            Block(border: noborder, blockY: 0, blockX: 2),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Block(
              border: Border.symmetric(
                horizontal: BorderSide(width: 2, color: Colors.black),
              ),
              blockY: 1,
              blockX: 0,
            ),
            Block(
              border: Border.all(width: 2, color: Colors.black),
              blockY: 1,
              blockX: 1,
            ),
            Block(
              border: Border.symmetric(
                horizontal: BorderSide(width: 2, color: Colors.black),
              ),
              blockY: 1,
              blockX: 2,
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Block(border: noborder, blockY: 2, blockX: 0),
            Block(
              border: Border.symmetric(
                vertical: BorderSide(width: 2, color: Colors.black),
              ),
              blockY: 2,
              blockX: 1,
            ),
            Block(border: noborder, blockY: 2, blockX: 2),
          ]),
        ],
      ),
    );
  }
}
