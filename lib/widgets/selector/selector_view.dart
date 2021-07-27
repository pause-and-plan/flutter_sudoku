import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SelectorView extends StatefulWidget {
  final List<String> list;
  final Function(int) onSelect;
  const SelectorView({
    required this.list,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  _SelectorViewState createState() => _SelectorViewState();
}

class _SelectorViewState extends State<SelectorView> {
  PageController _pageController = PageController();
  final Duration duration = const Duration(milliseconds: 400);
  final Curve curve = Curves.decelerate;
  int currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isFirstPage => currentPageIndex == 0;
  bool get _isLastPage => currentPageIndex == widget.list.length - 1;

  void _previous() {
    _pageController.previousPage(duration: duration, curve: curve);
  }

  void _next() {
    _pageController.nextPage(duration: duration, curve: curve);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _isFirstPage ? null : _previous,
          icon: Icon(Icons.chevron_left),
        ),
        SizedBox(width: 2.w),
        Container(
          height: 4.h,
          width: 40.w,
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                currentPageIndex = index;
              });
              widget.onSelect(index);
            },
            children: widget.list
                .map((String text) => SelectableItem(text: text))
                .toList(),
          ),
        ),
        SizedBox(width: 2.w),
        IconButton(
          onPressed: _isLastPage ? null : _next,
          icon: Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class SelectableItem extends StatelessWidget {
  final String text;
  const SelectableItem({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, textAlign: TextAlign.center));
  }
}
