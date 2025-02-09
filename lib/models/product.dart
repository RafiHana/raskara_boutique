class Product {
  final int? id;
  final String name;
  final double price;
  final String imagePath; // Tidak nullable

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath, // Wajib diisi
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: (map['price'] is num)
          ? map['price'].toDouble()
          : double.parse(map['price'].toString()),
      imagePath: (map['imagePath'] != null && map['imagePath'].isNotEmpty)
          ? map['imagePath']
          : 'assets/images/placeholder.png', 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
    };
  }
}
