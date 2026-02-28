class InventoryItem {
  final int id;
  final String sku;
  final String name;
  final String category;
  final int quantity;
  final int minStock;
  final String unit;
  final double unitPrice;
  final String supplier;
  final String location;
  final String lastUpdated;

  InventoryItem({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.quantity,
    required this.minStock,
    required this.unit,
    required this.unitPrice,
    required this.supplier,
    required this.location,
    required this.lastUpdated,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      sku: json['sku'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      minStock: json['minStock'] ?? json['min_stock'],
      unit: json['unit'],
      unitPrice: (json['unitPrice'] ?? json['unit_price'] as num).toDouble(),
      supplier: json['supplier'],
      location: json['location'],
      lastUpdated: json['lastUpdated'] ?? json['last_updated'],
    );
  }
}

class Supplier {
  final int id;
  final String name;
  final String contact;
  final String email;
  final String category;
  final int totalOrders;
  final double totalValue;
  final String status;
  final double rating;
  final String lastOrder;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.category,
    required this.totalOrders,
    required this.totalValue,
    required this.status,
    required this.rating,
    required this.lastOrder,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      email: json['email'],
      category: json['category'],
      totalOrders: json['totalOrders'] ?? json['total_orders'] ?? 0,
      totalValue: (json['totalValue'] ?? json['total_value'] ?? 0 as num).toDouble(),
      status: json['status'],
      rating: (json['rating'] ?? 0 as num).toDouble(),
      lastOrder: json['lastOrder'] ?? json['last_order'] ?? '',
    );
  }
}
