import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({Key? key}) : super(key: key);

  @override
  _SudokuScreenState createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          'Sudoku',
          style: TextStyle(
              color: Colors.black54,
              fontSize: 32,
              fontWeight: FontWeight.normal),
        ),
        actions: [
          ToggleIconButton(icon: Icons.done_all),
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.settings),
          ),
        ],
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(children: [
              LevelAndTimerSection(),
              GridSection(),
            ]),
            SymbolSection(),
            ActionsSection(),
          ],
        ),
      ),
    );
  }
}

class ActionsSection extends StatelessWidget {
  const ActionsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ToggleIconButton(
            icon: Icons.undo,
          ),
          ToggleIconButton(
            icon: Icons.check,
          ),
          ToggleIconButton(
            icon: Icons.edit,
          ),
          ToggleIconButton(
            icon: Icons.wb_incandescent,
          ),
          ToggleIconButton(
            icon: Icons.redo,
          ),
        ],
      ),
    );
  }
}

class SymbolSection extends StatelessWidget {
  const SymbolSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          9,
          (index) => ToggleSymbolButton(
            symbol: (index + 1).toString(),
          ),
        ),
      ),
    );
  }
}

class GridSection extends StatelessWidget {
  const GridSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final noborder = Border.all(width: 0, color: Colors.transparent);

    return Container(
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Block(border: noborder),
            Block(
              border: Border.symmetric(
                vertical: BorderSide(width: 2, color: Colors.black),
              ),
            ),
            Block(border: noborder),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Block(
              border: Border.symmetric(
                horizontal: BorderSide(width: 2, color: Colors.black),
              ),
            ),
            Block(
              border: Border.all(width: 2, color: Colors.black),
            ),
            Block(
              border: Border.symmetric(
                horizontal: BorderSide(width: 2, color: Colors.black),
              ),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Block(border: noborder),
            Block(
              border: Border.symmetric(
                vertical: BorderSide(width: 2, color: Colors.black),
              ),
            ),
            Block(border: noborder),
          ]),
        ],
      ),
    );
  }
}

class Block extends StatelessWidget {
  final BoxBorder border;
  const Block({required this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: border),
      child: Column(
        children: [
          Row(children: [
            Box(),
            Box(),
            Box(),
          ]),
          Row(children: [
            Box(),
            Box(),
            Box(),
          ]),
          Row(children: [
            Box(),
            Box(),
            Box(),
          ]),
        ],
      ),
    );
  }
}

class Box extends StatelessWidget {
  const Box({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool shouldShowAnnotations = false;
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: SizedBox(
        width: (width - 30 - 18 - 6) / 9,
        height: (width - 30 - 18 - 6) / 9,
        child: shouldShowAnnotations ? Annotations() : Symbol(),
      ),
    );
  }
}

class Annotations extends StatelessWidget {
  const Annotations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(children: [
            Text(
              '1',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                fontFamily: 'Signifika',
              ),
            ),
            Text('2',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('3',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
          ]),
          Row(children: [
            Text('4',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('5',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('6',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
          ]),
          Row(children: [
            Text('7',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('8',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
            Text('9',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                )),
          ]),
        ],
      ),
    );
  }
}

class ToggleSymbolButton extends StatelessWidget {
  final String symbol;
  const ToggleSymbolButton({this.symbol = ''});

  @override
  Widget build(BuildContext context) {
    return MyToggleButton(
      child: Text(
        symbol,
        style: TextStyle(color: Colors.black54, fontSize: 18),
      ),
    );
  }
}

class ToggleIconButton extends StatelessWidget {
  final IconData icon;
  const ToggleIconButton({this.icon = Icons.cancel});

  @override
  Widget build(BuildContext context) {
    return MyToggleButton(
      child: Icon(
        icon,
        color: Colors.black54,
      ),
    );
  }
}

class MyToggleButton extends StatefulWidget {
  final Widget child;
  const MyToggleButton({this.child = const Icon(Icons.cancel)});

  @override
  _MyToggleButtonState createState() => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> {
  bool elevated = false;

  void toggleElevation() => setState(() => elevated = !elevated);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 40,
        height: 40,
        child: FloatingActionButton(
            onPressed: toggleElevation,
            elevation: elevated ? 4 : 0,
            backgroundColor:
                elevated ? Colors.grey.shade300 : Colors.transparent,
            child: widget.child),
      ),
    );
  }
}

class Symbol extends StatelessWidget {
  const Symbol({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String symbol = '1';
    return Container(
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            fontFamily: 'Signifika',
          ),
        ),
      ),
    );
  }
}

class LevelAndTimerSection extends StatelessWidget {
  const LevelAndTimerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridLevel = 'facile';
    final startDateTime = DateTime.now();
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              gridLevel,
              style: TextStyle(color: Colors.black87),
            ),
          ),
          Row(
            children: [
              Text(
                DateTimeRange(start: startDateTime, end: DateTime.now())
                    .duration
                    .inSeconds
                    .toString(),
                style: TextStyle(color: Colors.black87),
              ),
              IconButton(
                onPressed: () => {},
                icon: Icon(
                  Icons.pause_circle_outline,
                  color: Colors.black54,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
