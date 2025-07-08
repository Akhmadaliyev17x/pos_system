import 'package:flutter/material.dart';
import 'package:milliyway_pos/domain/models/product_model.dart';

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
}
