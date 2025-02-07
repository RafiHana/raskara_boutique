import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../models/product.dart';

class ApiService {
  // static const String baseUrl = 'http://127.0.0.1:4000/api';
  static const String baseUrl = 'http://10.0.2.2:4000/api';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromMap(json)).toList();
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  static Future<void> addProduct(Product product, File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/products'));

    request.fields['name'] = product.name;
    request.fields['price'] = product.price.toString();

    var imageStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile(
      'image', imageStream, length,
      filename: imageFile.path.split('/').last,
      contentType: MediaType('image', 'png'),
    );
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan produk');
    }
  }

  static Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus produk');
    }
  }
}