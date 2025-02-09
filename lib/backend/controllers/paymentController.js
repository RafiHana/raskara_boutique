require("dotenv").config();
const midtransClient = require("midtrans-client");

const snap = new midtransClient.Snap({
  isProduction: false,
  serverKey: process.env.MIDTRANS_SERVER_KEY,
});

snap.apiConfig.auth = {
  username: process.env.MIDTRANS_SERVER_KEY,
  password: ''
};

exports.createTransaction = async (req, res) => {
  try {
    const { totalAmount, paymentMethod } = req.body;
    console.log(`🛒 Creating transaction for amount: ${totalAmount} with ${paymentMethod}`);

    // Define transaction details based on the selected payment method
    const transactionDetails = {
      transaction_details: {
        order_id: `order-${Date.now()}`, // Unique order ID
        gross_amount: totalAmount,
      },
      payment_type: paymentMethod.toLowerCase() === "gopay" ? "gopay" : "bank_transfer",
      bank_transfer: paymentMethod.toLowerCase() === "bca"
        ? { bank: "bca" }
        : paymentMethod.toLowerCase() === "briva"
        ? { bank: "bri" }
        : null,
    };

    // Create the transaction with Midtrans
    const transaction = await snap.createTransaction(transactionDetails);
    console.log(`✅ Transaction Created: ${JSON.stringify(transaction)}`);

    // Extract virtual account or payment details
    let virtualAccount = null;
    if (transaction.va_numbers && transaction.va_numbers.length > 0) {
      virtualAccount = transaction.va_numbers[0].va_number; // For BCA, BNI, BRI
    } else if (transaction.permata_va_number) {
      virtualAccount = transaction.permata_va_number; // For Permata Bank
    } else if (transaction.bill_key && transaction.biller_code) {
      virtualAccount = `${transaction.biller_code}${transaction.bill_key}`; // For BRIVA
    } else if (transaction.payment_type === "gopay") {
      virtualAccount = transaction.actions ? transaction.actions[0].url : null; // For GoPay
    }

    // If no virtual account is found, return an error
    if (!virtualAccount) {
      console.error("❌ Virtual Account tidak ditemukan dalam response Midtrans.");
      return res.status(400).json({ error: "Virtual Account tidak ditemukan." });
    }

    // Return the transaction details
    res.json({
      orderId: transactionDetails.transaction_details.order_id,
      paymentUrl: transaction.redirect_url,
      virtualAccount: virtualAccount,
    });
  } catch (error) {
    console.error("❌ Midtrans API Error:", error);
    if (error.ApiResponse) {
      console.error("Midtrans API Response:", error.ApiResponse);
    }
    res.status(500).json({ error: error.message });
  }
};

exports.getPaymentStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const statusResponse = await snap.transaction.status(orderId);
    res.json(statusResponse);
  } catch (error) {
    console.error("❌ Error fetching payment status:", error);
    res.status(500).json({ error: error.message });
  }
};