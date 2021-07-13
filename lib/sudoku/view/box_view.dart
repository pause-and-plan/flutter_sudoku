import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/model/box_model.dart';
import 'package:sizer/sizer.dart';

class BoxView extends StatelessWidget {
  final int index;

  const BoxView({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridBloc, GridState>(
      builder: (context, state) {
        Box box = state.boxList[index];
        Color color = Colors.blue.shade50;
        if (box.symbol.hasValue && box.disable) color = Colors.blue;
        String text = box.soluce.toString();
        if (box.isPuzzle) text = box.symbol.toString();
        if (state is GridCreation) text = '';

        return Container(
          alignment: Alignment.center,
          width: 10.w - 2,
          height: 10.w - 2,
          child: Container(
            alignment: Alignment.center,
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: color,
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
              // textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
