import 'package:flutter/material.dart';
import 'package:raskara_boutique/widgets/PaymentWebview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MidtransService {
  static Future<String?> createTransaction(double amount) async {
    print("Requesting Snap Token for amount: $amount...");

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:4000/api/create-payment"),
        body: jsonEncode({"totalAmount": amount}),
        headers: {"Content-Type": "application/json"},
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody.containsKey("snapToken")) {
          final snapToken = responseBody["snapToken"];
          print("✅ Snap Token received: $snapToken");
          return snapToken;
        } else {
          print("❌ No snapToken found in response.");
          return null;
        }
      } else {
        print("❌ Failed to get Snap Token. Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Error getting Snap Token: $e");
      return null;
    }
  }

  static void startPayment(BuildContext context, String snapToken) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWebView(snapToken: snapToken),
      ),
    );
  }
}
