import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/theme/theme.dart';
import 'package:sudoku_provider/sudoku_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SymbolBar extends StatelessWidget {
  const SymbolBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GridBloc gridBloc = context.read<GridBloc>();

    void onTapSymbol(Symbol symbol) {
      gridBloc.add(GridPressSymbolEvent(symbol));
    }

    void onTapErase() {
      gridBloc.add(GridPressEraseEvent());
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SymbolButton(
              onTap: () => onTapSymbol(Symbol.s1()),
              symbol: Symbol.s1(),
            ),
            SymbolButton(
              onTap: () => onTapSymbol(Symbol.s2()),
              symbol: Symbol.s2(),
            ),
            SymbolButton(
              onTap: () => onTapSymbol(Symbol.s3()),
              symbol: Symbol.s3(),
            ),
            SymbolButton(
              onTap: () => onTapSymbol(Symbol.s4()),
              symbol: Symbol.s4(),
            ),
            SymbolButton(
              onTap: () => onTapSymbol(Symbol.s5()),
              symbol: Symbol.s5(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SymbolButton(
              onTap: () => onTapSymbol(Symbol.s6()),
              symbol: Symbol.s6(),
            ),
            SymbolButton(
              onTap: () => onTapSymbol(Symbol.s7()),
              symbol: Symbol.s7(),
            ),
            SymbolButton(
              onTap: () => onTapSymbol(Symbol.s8()),
              symbol: Symbol.s8(),
            ),
            SymbolButton(
              onTap: () => onTapSymbol(Symbol.s9()),
              symbol: Symbol.s9(),
            ),
            EraseButton(onTap: onTapErase),
          ],
        ),
      ],
    );
  }
}

class SymbolButton extends StatelessWidget {
  final Symbol symbol;
  final VoidCallback onTap;
  const SymbolButton({
    Key? key,
    required this.symbol,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double size = 14.w > boxMaxSize ? boxMaxSize : 14.w;
    return Padding(
      padding: EdgeInsets.all(1.w),
      child: OutlinedButton(
        onPressed: onTap,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: SymbolView(symbol: symbol),
        ),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(14.w, 14.w)),
          minimumSize: MaterialStateProperty.all<Size>(Size(14.w, 14.w)),
          shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
        ),
      ),
    );
  }
}

class EraseButton extends StatelessWidget {
  final VoidCallback onTap;
  const EraseButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double size = 14.w > boxMaxSize ? boxMaxSize : 14.w;

    return Padding(
      padding: EdgeInsets.all(1.w),
      child: OutlinedButton(
        onPressed: onTap,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Text(
            'X',
            style: TextStyle(fontSize: 24.sp, color: Colors.white70),
          ),
        ),
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(14.w, 14.w)),
          minimumSize: MaterialStateProperty.all<Size>(Size(14.w, 14.w)),
          shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
        ),
      ),
    );
  }
}

class SymbolView extends StatelessWidget {
  final Symbol symbol;

  const SymbolView({
    required this.symbol,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      symbol.toString(),
      style: TextStyle(fontSize: 24.sp, color: Colors.white70),
    );
  }
}
