import 'package:flutter/material.dart';
import 'cart_screen.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaksi')),
      body: ListView.builder(
        itemCount: 10, 
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Produk $index'), 
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.payment),
                  onPressed: () {
                    // Navigasi ke halaman pembayaran
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}