import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetailScreen extends StatelessWidget {
  final String orderId;
  final double grossAmount;
  final String paymentUrl;
  final String? qrCodeUrl;

  const PaymentDetailScreen({
    Key? key,
    required this.orderId,
    required this.grossAmount,
    required this.paymentUrl,
    this.qrCodeUrl,
  }) : super(key: key);

  void _openPaymentUrl() async {
    if (await canLaunch(paymentUrl)) {
      await launch(paymentUrl);
    } else {
      print("Tidak bisa membuka URL pembayaran");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Detail Pembayaran"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Order ID", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(orderId, style: const TextStyle(fontSize: 18, color: Colors.blueAccent)),
            const Divider(),
            const Text("Total Pembayaran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Rp${grossAmount.toStringAsFixed(0)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            if (qrCodeUrl != null) Image.network(qrCodeUrl!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openPaymentUrl,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text("Bayar Sekarang", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
