class ProductModel {
  final String id;
  final String name;
  final String code;
  final double price;
  final int count;
  final double discount;
  final double sum;
  final String unit;

  //<editor-fold desc="Data Methods">
  const ProductModel({
    this.id = "",
    required this.name,
    required this.code,
    required this.price,
    required this.count,
    required this.discount,
    this.sum = 0,
    required this.unit,
  });

  /// Bo‘sh (default) ProductModel
  factory ProductModel.empty() {
    return const ProductModel(
      id: '',
      name: 'Noma\'lum mahsulot',
      code: '',
      price: 0,
      count: 0,
      discount: 0,
      sum: 0,
      unit: '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ProductModel && runtimeType == other.runtimeType && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProductModel{' +
        ' id: $id,' +
        ' name: $name,' +
        ' code: $code,' +
        ' price: $price,' +
        ' count: $count,' +
        ' discount: $discount,' +
        ' sum: $sum,' +
        ' unit: $unit,' +
        '}';
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? code,
    double? price,
    int? count,
    double? discount,
    double? sum,
    String? unit,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      price: price ?? this.price,
      count: count ?? this.count,
      discount: discount ?? this.discount,
      sum: sum ?? this.sum,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'price': price,
      'count': count,
      'discount': discount,
      'sum': sum,
      'unit': unit,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      code: map['code'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      count: map['count'] as int? ?? 0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      sum: (map['sum'] as num?)?.toDouble() ?? 0,
      unit: map['unit'] as String? ?? '',
    );
  }
//</editor-fold>
}
