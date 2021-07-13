import 'package:flutter/material.dart';
import 'package:sudoku/sudoku/view/box_view.dart';
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
    final double _height = 10.w - 2;
    return Container(
      height: _height,
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
    return Container(
      width: 1,
      height: 6.w,
      decoration: BoxDecoration(
        borderRadius: border,
        color: Colors.black12,
      ),
    );
  }
}

class DividerRow extends StatelessWidget {
  const DividerRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HorizontalDivider(),
          HorizontalDivider(),
          HorizontalDivider()
        ],
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6.w,
      height: 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.black12,
      ),
    );
  }
}
