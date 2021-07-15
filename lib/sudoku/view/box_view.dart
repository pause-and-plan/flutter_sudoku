import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/model/box_model.dart';
import 'package:sizer/sizer.dart';
import 'package:sudoku/theme/theme.dart';

class BoxView extends StatelessWidget {
  final int index;

  const BoxView({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridBloc, GridState>(
      builder: (context, state) {
        Box box = state.boxList[index];
        bool hideText = false;
        if (state is GridCreation) hideText = true;

        if (box.disable) {
          return BoxContainer(
            child: BasicBoxView(box: box, hideText: hideText),
          );
        } else {
          void onTap() {
            context.read<GridBloc>().add(GridPressBoxEvent(index));
          }

          return BoxContainer(
            child: SelectableBoxView(
              box: box,
              onTap: onTap,
              hideText: hideText,
            ),
          );
        }
      },
    );
  }
}

class BoxContainer extends StatelessWidget {
  final Widget child;
  const BoxContainer({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: boxMaxSize, maxHeight: boxMaxSize),
      child: Container(
        width: boxSize.w,
        height: boxSize.w,
        padding: EdgeInsets.all(0.9.w),
        child: child,
      ),
    );
  }
}

class SelectableBoxView extends StatelessWidget {
  final Box box;
  final bool hideText;
  final VoidCallback onTap;

  const SelectableBoxView({
    required this.box,
    required this.onTap,
    this.hideText = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = (boxSize / 2) - 1;
    return InkResponse(
      onTap: onTap,
      radius: size.w,
      child: Container(
        child: BasicBoxView(box: box, hideText: hideText),
      ),
    );
  }
}

class BasicBoxView extends StatelessWidget {
  final Box box;
  final bool hideText;

  const BasicBoxView({
    required this.box,
    this.hideText = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white.withOpacity(0.02);
    if (box.symbol.hasValue && box.disable) {
      bgColor = Colors.blueGrey.withOpacity(0.2);
    }
    if (box.isFocus) bgColor = Colors.blue;

    String text = box.soluce.toString();
    if (box.isPuzzle) text = box.symbol.toString();

    Color fontColor = Colors.white70;
    if (!box.isFocus && box.isPuzzle) fontColor = Colors.blue.shade200;
    if (box.isFocus) fontColor = Colors.black87;

    FontWeight fontWeight = FontWeight.normal;
    if (box.isFocus) fontWeight = FontWeight.bold;

    double size = (boxSize / 2) - 1;

    return Container(
      alignment: Alignment.center,
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: bgColor,
      ),
      child: Visibility(
        visible: !hideText,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            color: fontColor,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
