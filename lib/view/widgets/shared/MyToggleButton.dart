import 'package:flutter/material.dart';

class MyToggleButton extends StatelessWidget {
  final Widget child;
  final elevated;
  final VoidCallback onPress;
  final double size;
  final double padding;

  const MyToggleButton({
    Key? key,
    this.elevated = false,
    this.child = const Icon(Icons.cancel),
    required this.onPress,
    this.size = 40,
    this.padding = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        width: size,
        height: size,
        child: FloatingActionButton(
          onPressed: onPress,
          elevation: elevated ? 4 : 0,
          backgroundColor:
              elevated ? Colors.grey.shade300 : Colors.grey.shade50,
          child: child,
        ),
      ),
    );
  }
}
