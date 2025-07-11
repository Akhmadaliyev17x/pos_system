import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:milliyway_pos/core/router/route_names.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.currentIndex, required this.child});
  final int currentIndex;
  final Widget child;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MilliyWay POS",
          style: TextTheme.of(context).headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              isSelected = !isSelected;
              setState(() {});
            },
            icon: const Icon(Icons.menu, size: 35),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: widget.child),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
            height: double.infinity,
            width: isSelected ? 72 : 0,
            child: ClipRect(
              child: NavigationRail(
                selectedIndex: widget.currentIndex,
                onDestinationSelected: (int index) {
                  if (index !=  widget.currentIndex ) {
                    String page = switch (index) {
                      0 => Routes.home,
                      1=> Routes.settings,
                      _ => Routes.home,
                    };
                    context.go(page);
                  }
                },
                labelType: NavigationRailLabelType.selected,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text(''),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text(''),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
