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
          const Expanded(flex: 3, child: Column(
            children: [
              Expanded(flex: 5,child: Card(clipBehavior: Clip.antiAlias,child: ItemTable(),),),
              Expanded(flex : 2,child: ColoredBox(color: Colors.transparent, child: SizedBox.expand())),
            ],
          )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                spacing: 16,
                children: [
                  const TimerWidget(),
                  CustomSearchBar(
                    onChanged: (String value) {
                      search = value;
                    },
                  ),
                  PrimaryButton(
                    title: "Qidirish",
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                  const Expanded(flex: 4, child: SizedBox.shrink()),
                  Expanded(
                    child: Center(
                      child: Consumer<HomeProvider>(
                        builder: (_, value, __) {
                          return Text(
                            "${NumberFormat('#,##0', 'en_US').format(value.totalSum)} So'm",
                            style: Theme.of(context).textTheme.displaySmall,
                          );
                        },
                      ),
                    ),
                  ),
                  const PrimaryButton(title: "Chek"),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:milliyway_pos/feature/home/providers/scanner_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScannerProvider controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.read<ScannerProvider>(); // read ishlatildi
    controller.initialize();
  }

  void connectToPort(String portName) {
    final result = controller.scannerService.connect(portName);
    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Portga ulanishda xatolik: $portName')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerProvider>(
      builder: (context, controller, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Portni tanlang:'),
              DropdownButton<String>(
                value: controller.selectedPort,
                hint: const Text('Port tanlash'),
                items: controller.availablePorts.map((port) {
                  return DropdownMenuItem(value: port, child: Text(port));
                }).toList(),
                onChanged: (portName) {
                  if (portName != null) {
                    controller.selectPort(portName);
                    connectToPort(portName);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Ulanish holati: ${controller.isConnected ? "Ulangan" : "Uzilgan"}',
                style: TextStyle(
                  color: controller.isConnected ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Scanner ma\'lumotlari:'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(controller.scannerData),
                      Text(controller.product?.toString() ?? 'Mahsulot topilmadi'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
*/