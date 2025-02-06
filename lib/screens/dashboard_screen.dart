import 'package:flutter/material.dart';
import 'transaction_screen.dart';
import 'history_screen.dart';
import 'package:raskara_boutique/widgets/chart_widget.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Keluar dari aplikasi ketika tombol back ditekan
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboad'),
          automaticallyImplyLeading: false, // Menghilangkan tombol back
        ),
        body: Column(
          children: [
            ChartWidget(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionScreen()),
                );
              },
              child: Text('Transaksi'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: Text('Histori'),
            ),
          ],
        ),
      ),
    );
  }
}