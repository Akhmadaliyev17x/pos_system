import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milliyway_pos/domain/models/product_model.dart';
import 'package:milliyway_pos/feature/home/providers/home_provider.dart';
import 'package:milliyway_pos/feature/home/providers/scanner_provider.dart';
import 'package:milliyway_pos/services/port/db.dart';
import 'package:provider/provider.dart';

class ItemTable extends StatefulWidget {
  const ItemTable({super.key});

  @override
  State<ItemTable> createState() => _ItemTableState();
}

class _ItemTableState extends State<ItemTable> {
  late final ScannerProvider scannerController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scannerController = context.read<ScannerProvider>();
    scannerController.initialize();

    // Scanner ma'lumot kelganda ishlovchi
    scannerController.scannerService.onData.listen((data) {
      String cleanData = data.trim();

      if (cleanData.isNotEmpty) {
        // HomeProvider dagi findProduct metodini ishlatish
        ProductModel? product = context.read<HomeProvider>().findProduct(cleanData);

        if (product != null) {
          // Mahsulot topilsa, HomeProvider ga qo'shish
          context.read<HomeProvider>().addOrUpdateProductByCode(product);

          // Scanner ma'lumotini tozalash (ixtiyoriy)
          scannerController.clearScannerData();
        } else {
          // Mahsulot topilmasa, xabar berish
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Mahsulot topilmadi: $cleanData'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  /*void _handleScannerData(String scannerData) {
    // Scanner ma'lumotini tozalash
    String cleanData = scannerData.trim();
    if (cleanData.isNotEmpty) {
      // Barcode yoki product code bo'yicha mahsulot qidirish
      final homeProvider = context.read<HomeProvider>();

      // Agar mahsulot mavjud bo'lsa, sonini oshirish
      bool productExists = false;
      for (var item in homeProvider.items) {
        if (item.code == cleanData) {
          homeProvider.increaseProductCount(item);
          productExists = true;
          break;
        }
      }

      // Agar mahsulot mavjud bo'lmasa, yangi mahsulot qo'shish
      if (!productExists) {
        final newProduct = ProductModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: "Scanned Product",
          code: cleanData,
          price: 10000, // Default narx
          count: 1,
          discount: 0,
          unit: "dona",
        );
        homeProvider.addProduct(newProduct);
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(10),
              blurRadius: 12,
              spreadRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: colorScheme.onPrimary,
                    size: 36,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Mahsulotlar Jadvali',
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const Spacer(),

                  // Scanner Port Selector
                  Consumer<ScannerProvider>(
                    builder: (context, scanner, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.onPrimary.withAlpha(50),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              color: colorScheme.onPrimary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: scanner.selectedPort,
                              hint: Text(
                                'Scanner Port',
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              dropdownColor: colorScheme.surface,
                              underline: const SizedBox(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: colorScheme.onPrimary,
                              ),
                              items: scanner.availablePorts.map((port) {
                                return DropdownMenuItem(
                                  value: port,
                                  child: Text(
                                    port,
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (portName) {
                                if (portName != null) {
                                  scanner.selectPort(portName);
                                  scannerController.scannerService.connect(
                                    portName,
                                  );
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: scanner.isConnected
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 16),

                  // Delete All Button
                  Consumer<HomeProvider>(
                    builder: (_, value, child) => value.items.isNotEmpty
                        ? IconButton(
                            onPressed: () => _showDeleteDialog(context),
                            icon: Icon(
                              Icons.delete_forever,
                              color: colorScheme.onErrorContainer,
                              size: 32,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // Scanner Status Bar
            Consumer<ScannerProvider>(
              builder: (context, scanner, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: scanner.isConnected
                        ? Colors.green.withAlpha(20)
                        : Colors.orange.withAlpha(20),
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outline.withAlpha(30),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        scanner.isConnected
                            ? Icons.check_circle
                            : Icons.warning,
                        color: scanner.isConnected
                            ? Colors.green
                            : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        scanner.isConnected
                            ? 'Scanner ulangan: ${scanner.selectedPort ?? "N/A"}'
                            : 'Scanner ulanmagan',
                        style: TextStyle(
                          color: scanner.isConnected
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (scanner.scannerData.isNotEmpty) ...[
                        Text(
                          'Oxirgi scan: ${scanner.scannerData}',
                          style: TextStyle(
                            color: colorScheme.onSurface.withAlpha(70),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            // Table Content
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, value, child) {
                  if (value.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 100,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Hozircha ma'lumot yo'q",
                            style: theme.textTheme.headlineSmall!.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Mahsulot qo'shish uchun + tugmasini bosing yoki scanner orqali scan qiling",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: colorScheme.onSurface.withAlpha(70),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          border: Border(
                            bottom: BorderSide(
                              color: colorScheme.outline.withAlpha(30),
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
                      Expanded(
                        child: ListView.separated(
                          itemCount: value.items.length,
                          itemBuilder: (context, index) {
                            final reversedIndex = value.items.length - index;
                            final product = value.items.reversed
                                .toList()[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? colorScheme.surface
                                    : colorScheme.surfaceContainerHighest
                                          .withAlpha(30),
                                border: Border(
                                  bottom: BorderSide(
                                    color: colorScheme.outline.withAlpha(20),
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
                                    NumberFormat('#,###').format(product.price),
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
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(thickness: 2),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<HomeProvider>().addProduct(
          ProductModel(
            name: "Yangi mahsulot",
            code: "PRD${DateTime.now().microsecond}",
            price: 50000,
            count: 1,
            discount: 0,
            unit: "dona",
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add, size: 32),
        label: Text(
          'Mahsulot qo\'shish',
          style: theme.textTheme.labelLarge!.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.surface,
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: colorScheme.error,
              size: 32,
            ),
            const SizedBox(width: 16),
            Text(
              'Ishonchingiz komilmi?',
              style: theme.textTheme.headlineSmall!.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        content: Text(
          'Savatni o\'chirib tashlashni istaysizmi?',
          style: theme.textTheme.bodyMedium!.copyWith(
            color: colorScheme.onSurface,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Bekor qilish',
              style: theme.textTheme.labelLarge!.copyWith(
                color: colorScheme.onSurface.withAlpha(70),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<HomeProvider>().clearBasket();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'O\'chirish',
              style: theme.textTheme.labelLarge!.copyWith(
                color: colorScheme.onError,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required int flex}) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );

  Widget _buildDataCell(
    String text, {
    required int flex,
    bool isMultiline = false,
  }) => Expanded(
    flex: flex,
    child: Text(
      text,
      style: TextStyle(fontSize: 20, height: isMultiline ? 1.5 : 1.2),
      maxLines: isMultiline ? 2 : 1,
      overflow: TextOverflow.ellipsis,
    ),
  );

  Widget _buildActionButtons(
    BuildContext context,
    ProductModel product, {
    required int flex,
  }) => Expanded(
    flex: flex,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconButton(context, Icons.remove, () {
          if (product.count > 1) {
            context.read<HomeProvider>().decreaseProductCount(product);
          }
        }, Colors.orange),
        Text('${product.count}', style: const TextStyle(fontSize: 20)),
        _buildIconButton(context, Icons.add, () {
          context.read<HomeProvider>().increaseProductCount(product);
        }, Colors.green),
        _buildIconButton(context, Icons.delete_outline, () {
          context.read<HomeProvider>().removeProduct(product);
        }, Colors.red),
      ],
    ),
  );

  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
    Color color,
  ) => Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: color.withAlpha(10),
      shape: BoxShape.circle,
    ),
    child: IconButton(
      icon: Icon(icon, size: 28, color: color),
      onPressed: onPressed,
    ),
  );

  @override
  void dispose() {
    scannerController.scannerService.dispose();
    super.dispose();
  }
}
