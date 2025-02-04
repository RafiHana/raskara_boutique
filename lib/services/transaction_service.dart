import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct(Product product) async {
    await _firestore.collection('products').add({
      'name': product.name,
      'type': product.type,
      'size': product.size,
      'price': product.price,
      'imageUrl': product.imageUrl,
    });
  }

  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product(
          id: doc.id,
          name: doc['name'],
          type: doc['type'],
          size: doc['size'],
          price: doc['price'],
          imageUrl: doc['imageUrl'],
        );
      }).toList();
    });
  }
}