import 'package:flutter/material.dart';
import '../../../domain/models/product_model.dart';
import '../../../services/port/db.dart';
import '../../../services/port/scanner_service.dart';

class ScannerProvider extends ChangeNotifier {
  ScannerProvider() : scannerService = ScannerService();

  final ScannerService scannerService;
  List<String> availablePorts = [];
  String? selectedPort;
  String scannerData = '';
  ProductModel? product;
  bool isConnected = false;

  void initialize() {
    availablePorts = scannerService.getAvailablePorts();
    notifyListeners();

    // Scanner ma'lumot kelganda ishlovchi
    scannerService.onData.listen((data) {
      scannerData = data.trim(); // Ma'lumotni tozalash

      // dbProducts dan mahsulot qidirish
      product = _findProductInDatabase(scannerData);

      notifyListeners();
    });

    // Ulanish holati o'zgarganda
    scannerService.onConnectionChanged.listen((connected) {
      isConnected = connected;
      notifyListeners();
    });
  }

  // dbProducts dan mahsulot qidirish
  ProductModel? _findProductInDatabase(String code) {
    try {
      return dbProducts.firstWhere(
            (product) => product.code.trim().toLowerCase() == code.toLowerCase(),
      );
    } catch (e) {
      // Mahsulot topilmasa null qaytaradi
      return null;
    }
  }

  // Scanner ma'lumotini olish va mahsulotni qaytarish
  ProductModel? getScannedProduct() {
    if (scannerData.isNotEmpty) {
      return _findProductInDatabase(scannerData);
    }
    return null;
  }

  // Scanner ma'lumotini tozalash
  void clearScannerData() {
    scannerData = '';
    product = null;
    notifyListeners();
  }

  void selectPort(String port) {
    selectedPort = port;
    scannerData = '';
    product = null;
    notifyListeners();
  }

  @override
  void dispose() {
    scannerService.dispose();
    super.dispose();
  }
}