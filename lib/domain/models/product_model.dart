class ProductModel {
  String id;

  String name;
  String code;

  double price;

  int count ;

  double discount;
  double sum;
  String unit;

  //<editor-fold desc="Data Methods">
  ProductModel({
     this.id = "",
    required this.name,
    required this.code,
    required this.price,
     required this.count,
    required this.discount,
     this.sum  = 0,
    required this.unit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id);

  @override
  int get hashCode =>
      id.hashCode;

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
      'id': this.id,
      'name': this.name,
      'code': this.code,
      'price': this.price,
      'count': this.count,
      'discount': this.discount,
      'sum': this.sum,
      'unit': this.unit,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      price: map['price'] as double,
      count: map['count'] as int,
      discount: map['discount'] as double,
      sum: map['sum'] as double,
      unit: map['unit'] as String,
    );
  }

  //</editor-fold>
}