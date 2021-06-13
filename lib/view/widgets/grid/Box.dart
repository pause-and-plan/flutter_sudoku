import 'package:flutter/material.dart';
import 'Symbol.dart';
import 'Annotation.dart';

class Box extends StatelessWidget {
  const Box({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 500) width = 500;
    double size = (width - 30 - 18 - 6) / 9;
    bool shouldShowAnnotations = false;
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: SizedBox(
        width: size,
        height: size,
        child: shouldShowAnnotations ? Annotations() : Symbol(),
      ),
    );
  }
}
