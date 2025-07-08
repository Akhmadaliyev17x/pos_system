import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milliyway_pos/core/constants/app_colors.dart';
import 'package:milliyway_pos/core/constants/text_styles.dart';
import 'package:milliyway_pos/core/widgets/primary_button.dart';
import 'package:milliyway_pos/feature/home/providers/home_provider.dart';
import 'package:milliyway_pos/feature/home/widgets/items_table.dart';
import 'package:milliyway_pos/feature/home/widgets/timer.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_searchbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String search = "";
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
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 10),
        child: Row(
          children: [
            const Expanded(flex: 3, child: ItemTable()),
            Expanded(
              child: Column(
                spacing: 16,
                children: [
                  const TimerWidget(),
                  CustomSearchBar(onChanged: (String value) {
                    search = value;
                  }),
                  PrimaryButton(title: "Qidirish" , onPressed: (){setState(() {

                  });},),
                  const Expanded(flex: 4, child: SizedBox.shrink()),
                  Expanded(
                    child: Center(
                      child: Consumer<HomeProvider>(builder: (_, value, __) {
                        return Text(
                          "${NumberFormat('#,##0', 'en_US').format(value.totalSum)} So'm",
                          style: Theme.of(context).textTheme.displaySmall,
                        );                      }),
                    ),
                  ),
                  const PrimaryButton(title: "Chek"),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear,
              width: isSelected ? 72 : 0,
              child: ClipRect(
                child: NavigationRail(
                  selectedIndex: 0,
                  onDestinationSelected: (int index) {},
                  labelType: NavigationRailLabelType.selected,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text(''),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text(''),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
