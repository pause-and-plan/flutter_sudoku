import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/view/grid_page.dart';
import 'package:sudoku/theme/theme.dart';
// import 'package:sudoku_provider/sudoku_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Sudoku Demo',
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        home: BannerWidget(
          child: BlocProvider(
            create: (context) => GridBloc(),
            child: GridPage(),
          ),
        ),
      );
    });
  }
}

class BannerWidget extends StatelessWidget {
  final Widget child;
  const BannerWidget({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Banner(
      child: child,
      location: BannerLocation.topEnd,
      message: 'P&P',
      color: Colors.green.withOpacity(0.6),
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
        letterSpacing: 1.0,
        color: Colors.white70,
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
