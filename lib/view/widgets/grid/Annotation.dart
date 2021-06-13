import 'package:flutter/material.dart';

class Annotations extends StatelessWidget {
  const Annotations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(children: [
            Text(
              '1',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                fontFamily: 'Signifika',
              ),
            ),
            Text('2',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('3',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
          ]),
          Row(children: [
            Text('4',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('5',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('6',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
          ]),
          Row(children: [
            Text('7',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('8',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('9',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
          ]),
        ],
      ),
    );
  }
}
