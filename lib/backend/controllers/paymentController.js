require("dotenv").config();
const midtransClient = require("midtrans-client");

const snap = new midtransClient.Snap({
  isProduction: false,
  serverKey: process.env.MIDTRANS_SERVER_KEY,
});

exports.createTransaction = async (req, res) => {
  try {
    const { totalAmount, paymentMethod } = req.body;
    console.log(`🛒 Creating transaction for amount: ${totalAmount} with ${paymentMethod}`);

    const transactionDetails = {
      transaction_details: {
        order_id: `order-${Date.now()}`,
        gross_amount: totalAmount,
      },
      payment_type: "bank_transfer",
      bank_transfer: { bank: paymentMethod.toLowerCase() },
    };

    const transaction = await snap.createTransaction(transactionDetails);
    console.log(`✅ Transaction Created: ${transaction.redirect_url}`);

    res.json({
      orderId: String(transactionDetails.transaction_details.order_id),
      paymentUrl: transaction.redirect_url,
      qrCodeUrl: transaction.qr_code || null,
    });
  } catch (error) {
    console.error("❌ Midtrans API Error:", error);
    res.status(500).json({ error: error.message });
  }
};
