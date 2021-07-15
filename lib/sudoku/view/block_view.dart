import 'package:flutter/material.dart';
import 'package:sudoku/sudoku/view/box_view.dart';
import 'package:sudoku/theme/theme.dart';
import 'package:sudoku_provider/sudoku_provider.dart';
import 'package:sizer/sizer.dart';

class BlockView extends StatelessWidget {
  final int startIndex;
  const BlockView({required this.startIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlockRow(startIndex: startIndex + Grid.size * 0),
        DividerRow(),
        BlockRow(startIndex: startIndex + Grid.size * 1),
        DividerRow(),
        BlockRow(startIndex: startIndex + Grid.size * 2),
      ],
    );
  }
}

class BlockRow extends StatelessWidget {
  final int startIndex;
  const BlockRow({required this.startIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius border = BorderRadius.all(Radius.circular(10));
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BoxView(index: startIndex + 0),
          VerticalDivider(border: border),
          BoxView(index: startIndex + 1),
          VerticalDivider(border: border),
          BoxView(index: startIndex + 2),
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
    double size = boxSize - 4;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: boxMaxSize),
      child: Container(
        width: 1,
        height: size.w,
        decoration: BoxDecoration(
          borderRadius: border,
          color: Colors.white12,
        ),
      ),
    );
  }
}

class DividerRow extends StatelessWidget {
  const DividerRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [HorizontalDivider(), HorizontalDivider(), HorizontalDivider()],
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double size = boxSize - 4;
    double margin = (boxSize - size) / 2;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: boxMaxSize),
      child: Container(
        width: size.w,
        height: 1,
        margin: EdgeInsets.symmetric(horizontal: margin.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white12,
        ),
      ),
    );
  }
}
