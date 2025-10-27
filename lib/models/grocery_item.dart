class GroceryItem {
  int? id;
  String name;
  int quantity;
  String category;
  String? imagePath;
  bool isPurchased;

  GroceryItem({
    this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.imagePath,
    this.isPurchased = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'imagePath': imagePath,
      'purchased': isPurchased ? 1 : 0,
    };
  }

  factory GroceryItem.fromMap(Map<String, dynamic> map) {
    return GroceryItem(
      id: map['id'] is int ? map['id'] as int : int.tryParse(map['id'].toString()),
      name: map['name'] as String? ?? '',
      quantity: (map['quantity'] is int) ? map['quantity'] as int : int.tryParse(map['quantity'].toString()) ?? 1,
      category: map['category'] as String? ?? 'Produce',
      imagePath: map['imagePath'] as String?,
      isPurchased: (map['purchased'] ?? 0) == 1,
    );
  }
}
