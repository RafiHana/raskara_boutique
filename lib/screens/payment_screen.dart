import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/midtrans_service.dart';
import 'payment_detail_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = "BCA";

  void _handlePayment(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final totalAmount = cartProvider.totalPrice;
    print("🔄 Memproses pembayaran sebesar Rp$totalAmount...");

    final paymentData = await MidtransService.createTransaction(
      totalAmount,
      selectedPaymentMethod,
    );

    if (paymentData == null || paymentData["orderId"] == null) {
      print("❌ Gagal mendapatkan data pembayaran.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Gagal mendapatkan data pembayaran. Silakan coba lagi."),
        ),
      );
      return;
    }

    final String orderId = paymentData["orderId"].toString();
    final String? virtualAccount = paymentData["virtualAccount"]?.toString();

    if (virtualAccount == null) {
      print("❌ Virtual Account tidak ditemukan.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Virtual Account tidak ditemukan. Silakan coba lagi."),
        ),
      );
      return;
    }

    print("✅ Virtual Account diterima: $virtualAccount");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailScreen(
          orderId: orderId,
          grossAmount: totalAmount,
          virtualAccount: virtualAccount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderDetail(cartItems),
            const SizedBox(height: 20),
            _buildPaymentMethod(),
            const Spacer(),
            _buildBottomBar(context, cartProvider.totalPrice),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetail(List cartItems) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Detail",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ...cartItems.map((item) => _buildProductItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(product.name, style: const TextStyle(fontSize: 16)),
          ),
          Text(
            "Rp.${product.price.toStringAsFixed(0)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payment Method",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildPaymentOption("BCA", "assets/payment/bca.png"),
          _buildPaymentOption("BRIVA", "assets/payment/briva.png"),
          _buildPaymentOption("GoPay", "assets/payment/gopay.png"),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String method, String iconPath) {
    return ListTile(
      leading: Image.asset(iconPath, width: 40),
      title: Text(method),
      trailing: Radio<String>(
        value: method,
        groupValue: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value!;
          });
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.receipt, size: 28),
              const SizedBox(width: 10),
              const Text("Total", style: TextStyle(fontSize: 16)),
              const Spacer(),
              Text(
                "Rp.${totalPrice.toStringAsFixed(0)}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            // tombol Pay Now
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => _handlePayment(context),
            child: const Text("Pay Now",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
