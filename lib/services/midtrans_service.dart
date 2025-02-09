import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MidtransService {
  static String get serverKey => dotenv.env['MIDTRANS_SERVER_KEY'] ?? '';
  static const String midtransUrl =
      'https://app.sandbox.midtrans.com/snap/v1/transactions';

  static Future<Map<String, dynamic>?> createTransaction(
      double amount, String paymentMethod) async {
    print("🔄 Requesting Snap Token for amount: $amount...");
    try {
      final response = await http.post(
        Uri.parse(midtransUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode("$serverKey:"))}',
        },
        body: jsonEncode({
          "transaction_details": {
            "order_id": "order-${DateTime.now().millisecondsSinceEpoch}",
            "gross_amount": amount.toInt(),
          },
          "customer_details": {
            "first_name": "John",
            "last_name": "Doe",
            "email": "johndoe@example.com",
            "phone": "08123456789"
          },
          "payment_type": paymentMethod.toLowerCase() == "gopay"
              ? "gopay"
              : "bank_transfer",
          "bank_transfer": paymentMethod.toLowerCase() == "bca"
              ? {"bank": "bca"}
              : paymentMethod.toLowerCase() == "briva"
              ? {"bank": "bri"}
              : null,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("✅ Response: $data");
        if (data.containsKey("va_numbers")) {
          return {
            "orderId": data["order_id"],
            "virtualAccount": data["va_numbers"][0]["va_number"],
          };
        } else {
          return {
            "orderId": data["order_id"],
            "paymentUrl": data["redirect_url"],
          };
        }
      } else {
        print("❌ Failed to create transaction: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Error creating transaction: $e");
      return null;
    }
  }

  static Future<String> checkPaymentStatus(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:4000/api/payment-status/$orderId"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["transaction_status"]; // e.g., 'pending', 'settlement'
      } else {
        print("Failed to check payment status");
        return "pending";
      }
    } catch (e) {
      print("❌ Error checking payment status: $e");
      return "pending";
    }
  }
}
