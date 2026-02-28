class CanteenProduct {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String category;
  final int sales;

  CanteenProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.sales,
  });

  factory CanteenProduct.fromJson(Map<String, dynamic> json) {
    return CanteenProduct(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      category: json['category'],
      sales: json['sales'] ?? 0,
    );
  }
}

class CartItem {
  final CanteenProduct product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}
