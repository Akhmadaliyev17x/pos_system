import 'package:flutter/material.dart';
import 'package:milliyway_pos/domain/models/product_model.dart';

import '../../../services/port/db.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    calculateTotalSum();
  }

  List<ProductModel> _items = [
    ProductModel(
      id: '1',
      name: 'Laptop',
      code: 'LP1001',
      price: 1200,
      count: 2,
      discount: 10,
      sum: 2160,
      unit: 'pcs',
    ),
    ProductModel(
      id: '2',
      name: 'Smartphone',
      code: 'SP2002',
      price: 800,
      count: 3,
      discount: 5,
      sum: 2280,
      unit: 'pcs',
    ),
    ProductModel(
      id: '3',
      name: 'Headphones',
      code: 'HP3003',
      price: 150,
      count: 5,
      discount: 0,
      sum: 750,
      unit: 'pcs',
    ),
    ProductModel(
      id: '4',
      name: 'Keyboard',
      code: 'KB4004',
      price: 100,
      count: 4,
      discount: 20,
      sum: 320,
      unit: 'pcs',
    ),
    ProductModel(
      id: '5',
      name: 'Monitor',
      code: 'MN5005',
      price: 300,
      count: 2,
      discount: 15,
      sum: 510,
      unit: 'pcs',
    ),
  ];

  double _totalSum = 0;

  List<ProductModel> get items => _items;
  double get totalSum => _totalSum;

  /// Umumiy summani hisoblash
  void calculateTotalSum() {
    _totalSum = 0;
    for (var item in _items) {
      final itemSum = item.price * item.count * (1 - item.discount / 100);
      _totalSum += itemSum;
    }
    notifyListeners();
  }

  void clearBasket() {
    _items = [];
    calculateTotalSum();
  }

  ProductModel? findProduct(String code){
    for (var e in dbProducts) {
      if(e.code == code){
        return e;
      }
    }
    return null;
  }

  void addProduct(ProductModel product) {
    _items.add(product);
    calculateTotalSum();
  }

  void removeProduct(ProductModel product) {
    _items.removeWhere((e) => e.code == product.code);
    calculateTotalSum();
  }

  /// Mahsulot sonini oshirish
  void increaseProductCount(ProductModel product) {
    final index = _items.indexWhere((e) => e.code == product.code);
    if (index != -1) {
      final updatedProduct = product.copyWith(count: product.count + 1);
      _items[index] = updatedProduct;
      calculateTotalSum();
    }
  }

  /// Mahsulot sonini kamaytirish
  void decreaseProductCount(ProductModel product) {
    final index = _items.indexWhere((e) => e.code == product.code);
    if (index != -1 && product.count > 1) {
      final updatedProduct = product.copyWith(count: product.count - 1);
      _items[index] = updatedProduct;
      calculateTotalSum();
    }
  }

  /// Scanner orqali mahsulot qo'shish yoki mavjud mahsulot sonini oshirish
  bool addOrUpdateProductByCode(ProductModel product) {
    // Avval mavjud mahsulot bormi tekshirish
    final existingProductIndex = _items.indexWhere((item) => item.code == product.code);

    if (existingProductIndex != -1) {
      // Mahsulot mavjud bo'lsa, sonini oshirish
      final existingProduct = _items[existingProductIndex];
      increaseProductCount(existingProduct);
      return true;
    } else {
      // Mahsulot mavjud bo'lmasa, yangi mahsulot qo'shish
      final newProduct = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: product.name,
        code: product.code,
        price: product.price , // Default narx
        count: 1,
        discount: product.discount.toDouble(),
        unit: product.unit ,
      );
      addProduct(newProduct);
      return false; // Yangi mahsulot qo'shildi
    }
  }

  /// Code bo'yicha mahsulot qidirish
  ProductModel? findProductByCode(String code) {
    try {
      return _items.firstWhere((item) => item.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Mahsulot code bo'yicha mavjudligini tekshirish
  bool isProductExists(String code) {
    return _items.any((item) => item.code == code);
  }

  /// Mahsulot ma'lumotlarini yangilash
  void updateProduct(ProductModel updatedProduct) {
    final index = _items.indexWhere((item) => item.code == updatedProduct.code);
    if (index != -1) {
      _items[index] = updatedProduct;
      calculateTotalSum();
    }
  }

  /// Mahsulot narxini yangilash
  void updateProductPrice(String code, double newPrice) {
    final index = _items.indexWhere((item) => item.code == code);
    if (index != -1) {
      final updatedProduct = _items[index].copyWith(price: newPrice);
      _items[index] = updatedProduct;
      calculateTotalSum();
    }
  }

  /// Mahsulot chegirmasini yangilash
  void updateProductDiscount(String code, double newDiscount) {
    final index = _items.indexWhere((item) => item.code == code);
    if (index != -1) {
      final updatedProduct = _items[index].copyWith(discount: newDiscount);
      _items[index] = updatedProduct;
      calculateTotalSum();
    }
  }

  /// Mahsulot sonini o'rnatish
  void setProductCount(String code, int newCount) {
    final index = _items.indexWhere((item) => item.code == code);
    if (index != -1 && newCount > 0) {
      final updatedProduct = _items[index].copyWith(count: newCount);
      _items[index] = updatedProduct;
      calculateTotalSum();
    }
  }

  /// Jami mahsulotlar soni
  int get totalItemsCount {
    return _items.fold(0, (sum, item) => sum + item.count);
  }

  /// Turli mahsulotlar soni
  int get uniqueItemsCount {
    return _items.length;
  }
}