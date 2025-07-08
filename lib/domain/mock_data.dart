import 'models/product_model.dart';

final List<ProductModel> productList = [
  ProductModel(
    id: '1',
    name: 'Laptop',
    code: 'LP1001',
    price: 1200,
    count: 2,
    discount: 10,
    sum: 2160, // (1200 * 2) - 10%
    unit: 'pcs',
  ),
  ProductModel(
    id: '2',
    name: 'Smartphone',
    code: 'SP2002',
    price: 800,
    count: 3,
    discount: 5,
    sum: 2280, // (800 * 3) - 5%
    unit: 'pcs',
  ),
  ProductModel(
    id: '3',
    name: 'Headphones',
    code: 'HP3003',
    price: 150,
    count: 5,
    discount: 0,
    sum: 750, // (150 * 5)
    unit: 'pcs',
  ),
  ProductModel(
    id: '4',
    name: 'Keyboard',
    code: 'KB4004',
    price: 100,
    count: 4,
    discount: 20,
    sum: 320, // (100 * 4) - 20%
    unit: 'pcs',
  ),
  ProductModel(
    id: '5',
    name: 'Monitor',
    code: 'MN5005',
    price: 300,
    count: 2,
    discount: 15,
    sum: 510, // (300 * 2) - 15%
    unit: 'pcs',
  ),
];
