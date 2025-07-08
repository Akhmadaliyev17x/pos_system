import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milliyway_pos/core/constants/app_colors.dart';
import 'package:milliyway_pos/domain/models/product_model.dart';
import 'package:milliyway_pos/feature/home/providers/home_provider.dart';
import 'package:provider/provider.dart';

class ItemTable extends StatelessWidget {
  const ItemTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.indigoPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Mahsulotlar Jadvali',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Consumer<HomeProvider>(
                      builder: (_, value, child) {
                        if (value.items.isNotEmpty) {
                          return IconButton.filled(
                            onPressed: () => _showDeleteDialog(context),
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.red.shade700,
                              size: 25,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

              // Table Content
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    if (value.items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Hozircha ma'lumot yo'q",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Mahsulot qo'shish uchun + tugmasini bosing",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              _buildHeaderCell('N', flex: 1),
                              _buildHeaderCell('Nomi / Shrix Kod', flex: 3),
                              _buildHeaderCell('Narxi', flex: 2),
                              _buildHeaderCell('Chegirma', flex: 2),
                              _buildHeaderCell('Summa', flex: 2),
                              _buildHeaderCell('Unit', flex: 2),
                              _buildHeaderCell('Soni', flex: 2),
                            ],
                          ),
                        ),

                        // Table Rows
                        Expanded(
                          child: ListView.builder(
                            itemCount: value.items.length,
                            itemBuilder: (context, index) {
                              final reversedIndex = value.items.length - index;
                              final product = value.items.reversed
                                  .toList()[index];

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : Colors.grey.shade50,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    _buildDataCell('$reversedIndex', flex: 1),
                                    _buildDataCell(
                                      '${product.name}\n(${product.code})',
                                      flex: 3,
                                      isMultiline: true,
                                    ),
                                    _buildDataCell(
                                      NumberFormat(
                                        '#,###',
                                      ).format(product.price),
                                      flex: 2,
                                    ),
                                    _buildDataCell(
                                      '${product.discount}%',
                                      flex: 2,
                                    ),
                                    _buildDataCell(
                                      NumberFormat('#,###').format(product.sum),
                                      flex: 2,
                                    ),
                                    _buildDataCell(product.unit, flex: 2),
                                    _buildActionButtons(
                                      context,
                                      product,
                                      flex: 2,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<HomeProvider>().addProduct(
            ProductModel(
              name: "Yangi mahsulot",
              code: "PRD${DateTime.now().microsecond /DateTime.now().millisecond  }",
              price: 50000,
              count: 1,
              discount: 0,
              unit: "dona",
            ),
          );
        },
        backgroundColor: AppColors.indigoPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Mahsulot qo\'shish',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.red.shade600,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Ishonchingiz komilmi?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Savatni o\'chirib tashlashni istaysizmi?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Bekor qilish',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<HomeProvider>().clearBasket();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'O\'chirish',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    required int flex,
    bool isMultiline = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: Colors.black87,
          height: isMultiline ? 1.3 : 1.0,
        ),
        maxLines: isMultiline ? 2 : 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    ProductModel product, {
    required int flex,
  }) {
    return Expanded(
      flex: flex,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Kamaytirish button
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: IconButton(
              onPressed: () {
                if (product.count > 1) {
                  context.read<HomeProvider>().decreaseProductCount(product);
                }
              },
              icon: Icon(Icons.remove, color: Colors.orange.shade700, size: 16),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          // Sonini ko'rsatish
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${product.count}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.indigoPrimary,
                fontSize: 12,
              ),
            ),
          ),

          // Oshirish button
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.shade300),
            ),
            child: IconButton(
              onPressed: () {
                context.read<HomeProvider>().increaseProductCount(product);
              },
              icon: Icon(Icons.add, color: Colors.green.shade700, size: 16),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          const SizedBox(width: 8),

          // O'chirish button
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: IconButton(
              onPressed: () {
                context.read<HomeProvider>().removeProduct(product);
              },
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red.shade700,
                size: 16,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
