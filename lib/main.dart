import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:sudoku/navigation/bloc/nav_bloc.dart';
import 'package:sudoku/navigation/view/my_navigator.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/bloc/timer_bloc.dart';
import 'package:sudoku/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TimerBloc timerBloc = TimerBloc();
    GridBloc gridBloc = GridBloc(timerBloc: timerBloc);
    NavBloc navBloc = NavBloc();

    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Sudoku',
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        home: BannerWidget(
            child: MultiBlocProvider(
          providers: [
            BlocProvider<NavBloc>(create: (context) => navBloc),
            BlocProvider<TimerBloc>(create: (context) => timerBloc),
            BlocProvider<GridBloc>(create: (context) => gridBloc),
          ],
          child: BannerWidget(child: MyNavigator()),
        )),
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
      location: BannerLocation.bottomEnd,
      message: 'P&P',
      color: Colors.green.withOpacity(0.6),
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12.0,
        letterSpacing: 1.0,
        color: Colors.white70,
      ),
      textDirection: TextDirection.ltr,
      child: child,
    );
  }
}
