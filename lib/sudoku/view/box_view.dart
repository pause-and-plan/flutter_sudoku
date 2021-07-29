import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/model/box_model.dart';
import 'package:sizer/sizer.dart';
import 'package:sudoku/theme/theme.dart';
import 'package:sudoku_provider/sudoku_provider.dart';

class BoxView extends StatelessWidget {
  final int index;

  const BoxView({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridBloc, GridState>(
      builder: (context, state) {
        Box box = state.boxList[index];
        bool hideText = false;
        if (state.isInCreation) hideText = true;

        if (box.disable) {
          return BoxContainer(
            child: BasicBoxView(
              box: box,
              hideText: hideText,
              showError: box.hasError && state.soluce,
            ),
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
              showError: state.soluce,
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
        padding: EdgeInsets.all(0.4.w),
        child: child,
      ),
    );
  }
}

class SelectableBoxView extends StatelessWidget {
  final Box box;
  final bool hideText;
  final bool showError;
  final VoidCallback onTap;

  const SelectableBoxView({
    required this.box,
    required this.onTap,
    this.hideText = false,
    this.showError = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = (boxSize / 2) - 1;
    return InkResponse(
      onTap: onTap,
      radius: size.w,
      child: Container(
        child: BasicBoxView(box: box, hideText: hideText, showError: showError),
      ),
    );
  }
}

class BasicBoxView extends StatelessWidget {
  final Box box;
  final bool hideText;
  final bool showError;

  const BasicBoxView({
    required this.box,
    this.hideText = false,
    this.showError = false,
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

    if (showError && box.hasError) {
      if (box.isFocus) {
        bgColor = Colors.red;
      } else {
        bgColor = Colors.red.withOpacity(0.2);
        fontColor = Colors.white70;
      }
    }

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
        child: box.annotations.isNotEmpty
            ? AnnotationView(annotations: box.annotations, color: fontColor)
            : SymbolView(
                text: text,
                color: fontColor,
                fontWeight: fontWeight,
              ),
      ),
    );
  }
}

class SymbolView extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  const SymbolView({
    required this.text,
    required this.color,
    required this.fontWeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}

class AnnotationView extends StatelessWidget {
  final List<Symbol> annotations;
  final Color color;
  const AnnotationView({
    required this.annotations,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        TextStyle(color: color, fontSize: 8.sp, fontWeight: FontWeight.bold);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(annotations.contains(Symbol.s1()) ? '1' : ' ', style: style),
            SizedBox(width: 2),
            Text(annotations.contains(Symbol.s2()) ? '2' : ' ', style: style),
            SizedBox(width: 2),
            Text(annotations.contains(Symbol.s3()) ? '3' : ' ', style: style),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(annotations.contains(Symbol.s4()) ? '4' : ' ', style: style),
            SizedBox(width: 2),
            Text(annotations.contains(Symbol.s5()) ? '5' : ' ', style: style),
            SizedBox(width: 2),
            Text(annotations.contains(Symbol.s6()) ? '6' : ' ', style: style),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(annotations.contains(Symbol.s7()) ? '7' : ' ', style: style),
            SizedBox(width: 2),
            Text(annotations.contains(Symbol.s8()) ? '8' : ' ', style: style),
            SizedBox(width: 2),
            Text(annotations.contains(Symbol.s9()) ? '9' : ' ', style: style),
          ],
        )
      ],
    );
  }
}
