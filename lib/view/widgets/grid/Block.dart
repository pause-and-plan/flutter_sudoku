import 'package:flutter/material.dart';
import 'Box.dart';

class Block extends StatelessWidget {
  final BoxBorder border;
  const Block({required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: border),
      child: Column(
        children: [
          Row(children: [
            Box(),
            Box(),
            Box(),
          ]),
          Row(children: [
            Box(),
            Box(),
            Box(),
          ]),
          Row(children: [
            Box(),
            Box(),
            Box(),
          ]),
        ],
      ),
    );
  }
}
