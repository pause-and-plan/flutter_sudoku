import 'package:flutter/material.dart';

class Annotations extends StatelessWidget {
  final List<bool> list;
  const Annotations({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(
        9,
        (index) => Center(
          child: Text(
            list[index] ? (index + 1).toString() : '',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'Signifika',
            ),
          ),
        ),
      ),
    );
  }
}
