import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HistoryDetailScreen extends StatelessWidget {
  void downloadCSV() async {
    List<List<dynamic>> rows = [];
    rows.add(["Tanggal", "Produk", "Jumlah", "Harga"]);
    rows.add(["2023-10-01", "Produk A", 1, 10000]);
    rows.add(["2023-10-02", "Produk B", 2, 20000]);

    String csv = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/histori_pembelian.csv";
    File file = File(path);
    await file.writeAsString(csv);
    print("CSV downloaded at $path");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Histori')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail produk yang telah dijual'),
            ElevatedButton(
              onPressed: downloadCSV,
              child: Text('Download CSV'),
            ),
          ],
        ),
      ),
    );
  }
}