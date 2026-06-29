const prisma = require('../config/database');

const generateMonthlyReport = async () => {
  const transactions = await prisma.transaction.findMany({
    include: {
      asset: true,
    },
  });

  let csv =
    'Invoice,Pelanggan,Aset,Total,Status,Tanggal\n';

  transactions.forEach((trx) => {
    csv +=
      `${trx.invoiceNumber},` +
      `${trx.customerName},` +
      `${trx.asset?.name || '-'},` +
      `${trx.totalCost},` +
      `${trx.paymentStatus || '-'},` +
      `${trx.createdAt.toISOString()}\n`;
  });

  return csv;
};

module.exports = {
  generateMonthlyReport,
};