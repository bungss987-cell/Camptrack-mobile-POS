const prisma = require('../config/database');

const processPaymentCallback = async ({
  invoiceNumber,
  status,
  amount,
  paymentMethod,
  transactionTime,
}) => {
  const transaction = await prisma.transaction.findUnique({
    where: {
      invoiceNumber,
    },
  });

  if (!transaction) {
    const error = new Error('Invoice tidak ditemukan');
    error.statusCode = 404;
    throw error;
  }

  const updatedTransaction = await prisma.transaction.update({
    where: {
      invoiceNumber,
    },
    data: {
      paymentStatus: status,
      paymentMethod,
      paidAmount: amount ? Number(amount) : null,
      paymentTime: transactionTime
        ? new Date(transactionTime)
        : new Date(),
    },
  });

  return updatedTransaction;
};

module.exports = {
  processPaymentCallback,
};