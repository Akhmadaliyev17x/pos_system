import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
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
        ],
      ),
    );
  }
}
