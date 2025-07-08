import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';

class ProductsTable extends StatelessWidget {
  const ProductsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(4),
        child: SizedBox.expand(
          child: Consumer<HomeProvider>(
            builder: (BuildContext context, value, Widget? child) {
              if (value.items.isEmpty) {
                return Center(child: Text("No data yet"));
              }
              return DataTable(
                columns: const [
                  DataColumn(label: Text('N')),
                  DataColumn(label: Text('Nomi Shrix Kod')),
                  DataColumn(label: Text('Narxi')),
                  DataColumn(label: Text('Soni')),
                  DataColumn(label: Text('Chegirma')),
                  DataColumn(label: Text('Summa')),
                  DataColumn(label: Text('Unit')),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text("data"))]),
                ],
                border: TableBorder.all(color: Colors.grey.shade400),
                headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
