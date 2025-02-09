const midtransClient = require('midtrans-client');

const snap = new midtransClient.Snap({
  isProduction: false, 
  serverKey: 'SB-Mid-server-dqI0J3bzpOwoFIlNCFG3Lo_4'
});

exports.createTransaction = async (req, res) => {
  try {
    const { totalAmount } = req.body;
    console.log(`Creating transaction for amount: ${totalAmount}`);

    const transactionDetails = {
      transaction_details: {
        order_id: `order-${Date.now()}`,
        gross_amount: totalAmount,
      }
    };

    const snapToken = await snap.createTransaction(transactionDetails);
    console.log(`Snap Token received: ${snapToken.token}`);

    res.json({ snapToken: snapToken.token });
  } catch (error) {
    console.error("Midtrans API Error:", error);
    res.status(500).json({ error: error.message });
  }
};

