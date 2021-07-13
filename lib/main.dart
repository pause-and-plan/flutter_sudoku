import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:sudoku/sudoku/bloc/grid_bloc.dart';
import 'package:sudoku/sudoku/view/grid_page.dart';
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
        theme: ThemeData(primarySwatch: Colors.blue),
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

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sudoku app'),
//       ),
//       body: Container(),
//     );
//   }
// }

// class GridView extends StatelessWidget {
//   const GridView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Grid grid = Grid(
//       boxList: List.generate(Grid.length, (_) {
//         return Box(availableSymbols: Symbols.list()..shuffle());
//       }),
//     );
//     final gridBuilder = GridBuilder(grid: grid);
//     // final Stream<GridBuildState> _gridStream = gridBuilder.build();
//     return BlocProvider<GridBloc>(
//       create: (context) => GridBloc(buildStream: gridBuilder.build()),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           GridRow(rowStartIndex: 0),
//           GridRow(rowStartIndex: 27),
//           GridRow(rowStartIndex: 54),
//         ],
//       ),
//     );
//   }
// }

// class GridRow extends StatelessWidget {
//   final int rowStartIndex;

//   const GridRow({required this.rowStartIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         BlockView(blockStartIndex: rowStartIndex + 0),
//         BlockView(blockStartIndex: rowStartIndex + 3),
//         BlockView(blockStartIndex: rowStartIndex + 6),
//       ],
//     );
//   }
// }

// class BlockView extends StatelessWidget {
//   final int blockStartIndex;

//   const BlockView({required this.blockStartIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(children: [
//         BlockRow(rowStartIndex: blockStartIndex + 0 * Grid.size),
//         Divider(),
//         BlockRow(rowStartIndex: blockStartIndex + 1 * Grid.size),
//         Divider(),
//         BlockRow(rowStartIndex: blockStartIndex + 2 * Grid.size),
//       ]),
//     );
//   }
// }

// class BlockRow extends StatelessWidget {
//   final int rowStartIndex;

//   const BlockRow({required this.rowStartIndex});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(children: [
//         BoxView(index: rowStartIndex + 0),
//         Divider(color: Colors.blueGrey),
//         BoxView(index: rowStartIndex + 1),
//         Divider(),
//         BoxView(index: rowStartIndex + 2),
//       ]),
//     );
//   }
// }

// class BoxView extends StatelessWidget {
//   final int index;

//   const BoxView({required this.index, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<GridBloc, GridState>(
//       builder: (context, state) {
//         Box box = state.state.grid?.getBox(index) ?? Box.initial();
//         Color color = box.isPuzzle ? Colors.amber : Colors.transparent;
//         String text = (box.isPuzzle ? '0' : box.symbol.toString()) + '    ';
//         return Container(
//           color: color,
//           child: Text(
//             text,
//             // index.toString(),
//             style: Theme.of(context).textTheme.headline3,
//           ),
//         );
//       },
//     );
//   }
// }
