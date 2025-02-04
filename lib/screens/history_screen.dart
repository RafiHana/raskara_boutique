import 'package:flutter/material.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histori')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Histori Pembelian $index'), 
            trailing: IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryDetailScreen()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}