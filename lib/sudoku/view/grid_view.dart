import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sudoku/sudoku/view/block_view.dart';
import 'package:sudoku/theme/theme.dart';
import 'package:sudoku_provider/sudoku_provider.dart';
import 'package:sizer/sizer.dart';

class GridWidget extends StatelessWidget {
  const GridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GridRow(rowIndex: 0),
          HorizontalDivider(),
          GridRow(rowIndex: 1),
          HorizontalDivider(),
          GridRow(rowIndex: 2),
        ],
      ),
    );
  }
}

class GridRow extends StatelessWidget {
  final int rowIndex;

  const GridRow({required this.rowIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius border = BorderRadius.zero;
    if (rowIndex == 0) {
      border = BorderRadius.vertical(top: Radius.circular(10));
    } else if (rowIndex == 2) {
      border = BorderRadius.vertical(bottom: Radius.circular(10));
    }
    return Container(
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
    double height = boxSize.w * 3 + 2;
    double maxHeight = boxMaxSize * 3 + 2;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        width: 2,
        height: height,
        decoration: BoxDecoration(
          borderRadius: border,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = boxSize.w * 9 + 10;
    double maxWidth = boxMaxSize * 9 + 10;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        width: width,
        height: 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
