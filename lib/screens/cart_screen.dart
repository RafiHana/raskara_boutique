import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Keranjang')),
      body: Center(child: Text('Daftar produk di keranjang')),
    );
  }
}