import 'package:flutter/material.dart';

class MyToggleButton extends StatelessWidget {
  final Widget child;
  final elevated;
  final VoidCallback onPress;
  const MyToggleButton({
    Key? key,
    this.elevated = false,
    this.child = const Icon(Icons.cancel),
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 40,
        height: 40,
        child: FloatingActionButton(
          onPressed: onPress,
          elevation: elevated ? 4 : 0,
          backgroundColor: elevated ? Colors.grey.shade300 : Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}
