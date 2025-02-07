// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/product.dart';

// class ProductService {
//   final CollectionReference productsCollection =
//       FirebaseFirestore.instance.collection('products');

//   Future<List<Product>> fetchProducts() async {
//     QuerySnapshot snapshot = await productsCollection.get();
//     return snapshot.docs.map((doc) {
//       return Product(
//         id: doc.id,
//         name: doc['name'],
//         imagePath: doc['imagePath'],
//         price: (doc['price'] as num).toDouble(),
//       );
//     }).toList();
//   }

//   Future<void> addProduct(Product product) async {
//     await productsCollection.add({
//       'name': product.name,
//       'imagePath': product.imagePath,
//       'price': product.price,
//     });
//   }
// }
