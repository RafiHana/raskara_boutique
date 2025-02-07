class Product {
  final int? id;
  final String name;
  final double price;
  final String imagePath;

  Product({this.id, required this.name, required this.price, required this.imagePath});

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: (map['price'] is num) ? map['price'].toDouble() : double.parse(map['price'].toString()), 
      imagePath: map['imagePath'],
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


