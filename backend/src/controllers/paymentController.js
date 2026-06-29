const paymentService = require('../services/paymentService');
const { broadcast } = require('../utils/websocket');

const paymentCallback = async (req, res, next) => {
  try {
    const { invoice_number, status, amount, payment_method, transaction_time } = req.body;

    if (!invoice_number || !status) {
      return res.status(400).json({
        success: false,
        message: 'invoice_number dan status wajib ada',
      });
    }

    const updatedTransaction = await paymentService.processPaymentCallback({
      invoiceNumber: invoice_number,
      status,
      amount,
      paymentMethod: payment_method,
      transactionTime: transaction_time,
    });

    if (status === 'SUCCESS') {
      broadcast('PAYMENT_SUCCESS', {
        invoiceNumber: invoice_number,
        amount,
        paymentMethod: payment_method,
        message: 'Pembayaran berhasil diterima!',
      });
    } else if (status === 'FAILED') {
      broadcast('PAYMENT_FAILED', {
        invoiceNumber: invoice_number,
        message: 'Pembayaran gagal.',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Webhook diterima dan diproses',
    });
  } catch (err) {
    next(err);
  }
};

module.exports = { paymentCallback };