import 'package:flutter/material.dart';

class Symbol extends StatelessWidget {
  const Symbol({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String symbol = '1';
    return Container(
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            fontFamily: 'Signifika',
          ),
        ),
      ),
    );
  }
}
