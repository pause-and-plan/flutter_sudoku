import 'package:flutter/material.dart';
import 'package:sudoku/sudoku/view/block_view.dart';
import 'package:sudoku_provider/sudoku_provider.dart';
import 'package:sizer/sizer.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GridRow(rowIndex: 0),
        HorizontalDivider(),
        GridRow(rowIndex: 1),
        HorizontalDivider(),
        GridRow(rowIndex: 2),
      ],
    );
  }
}

class GridRow extends StatelessWidget {
  final int rowIndex;

  const GridRow({required this.rowIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius border = BorderRadius.zero;
    final double _height = 30.w;
    if (rowIndex == 0) {
      border = BorderRadius.vertical(top: Radius.circular(10));
    } else if (rowIndex == 2) {
      border = BorderRadius.vertical(bottom: Radius.circular(10));
    }
    return Container(
      height: _height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlockView(startIndex: Grid.size * rowIndex * 3 + 0),
          VerticalDivider(border: border),
          BlockView(startIndex: Grid.size * rowIndex * 3 + 3),
          VerticalDivider(border: border),
          BlockView(startIndex: Grid.size * rowIndex * 3 + 6),
        ],
      ),
    );
  }
}

class VerticalDivider extends StatelessWidget {
  final BorderRadius border;

  const VerticalDivider({required this.border, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 90.w,
      decoration: BoxDecoration(
        borderRadius: border,
        color: Colors.black38,
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.black38,
      ),
    );
  }
}
