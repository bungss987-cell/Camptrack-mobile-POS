const prisma = require("../config/database");

const DAILY_LATE_FINE = 20000;

const generateInvoiceNumber = () => {
  return `INV-${Date.now()}`;
};

const generateTrackingNumber = () => {
  return `CT-${Date.now()}`;
};

const getAllTransactions = async () => {
  return await prisma.transaction.findMany({
    include: {
      asset: true,
      shipment: true,
    },
    orderBy: {
      id: "desc",
    },
  });
};

const getTransactionById = async (id) => {
  const transaction = await prisma.transaction.findUnique({
    where: { id },
    include: {
      asset: true,
      shipment: true,
    },
  });

  if (!transaction) {
    throw new Error("Transaksi tidak ditemukan");
  }

  return transaction;
};

const createTransaction = async (data, userId) => {
  if (!userId) {
    throw new Error("User ID wajib disertakan");
  }

  const asset = await prisma.asset.findUnique({
    where: {
      id: Number(data.assetId),
    },
  });

  if (!asset) {
    throw new Error("Aset tidak ditemukan");
  }

  const quantity = Number(data.quantity) || 1;

  if (asset.stock < quantity) {
    throw new Error("Stok tidak mencukupi");
  }

  const startDate = new Date(data.startDate);
  const endDate = new Date(data.endDate);

  const diffDays =
    Math.ceil(
      (endDate - startDate) /
        (1000 * 60 * 60 * 24)
    ) || 1;

  const shippingCost =
    Number(data.shippingCost) || 0;

  const totalCost =
    asset.rentalPrice *
      diffDays *
      quantity +
    shippingCost;

  // Create transaction
  const transaction =
    await prisma.transaction.create({
      data: {
        invoiceNumber: generateInvoiceNumber(),

        customerName: data.customerName,
        customerPhone: data.customerPhone,
        customerAddress: data.customerAddress,

        assetId: Number(data.assetId),
        userId: userId,
        quantity: quantity,

        startDate,
        endDate,

        totalCost,
        shippingCost,

        paymentMethod: null,
        paymentStatus: "PENDING",
        paidAmount: 0,
        paymentTime: null,

        transactionStatus: "ONGOING",
      },
    });

  // Auto-create shipment for this transaction
  await prisma.shipment.create({
    data: {
      transactionId: transaction.id,
      trackingNumber: generateTrackingNumber(),
      courierName: data.courierName || "JNE",
      recipientName: data.customerName,
      recipientPhone: data.customerPhone || null,
      deliveryAddress: data.customerAddress || "-",
      shippingCost: shippingCost,
      status: "PENDING",
    },
  });

  // Decrement asset stock
  await prisma.asset.update({
    where: {
      id: asset.id,
    },
    data: {
      stock: {
        decrement: quantity,
      },
    },
  });

  // Return transaction with shipment included
  const fullTransaction = await prisma.transaction.findUnique({
    where: { id: transaction.id },
    include: {
      asset: true,
      shipment: true,
    },
  });

  return fullTransaction;
};

const processReturn = async (
  transactionId,
  data
) => {
  const trx =
    await prisma.transaction.findUnique({
      where: {
        id: transactionId,
      },
    });

  if (!trx) {
    throw new Error(
      "Transaksi tidak ditemukan"
    );
  }

  const actualReturnDate =
    data.actualReturnDate
      ? new Date(data.actualReturnDate)
      : new Date();

  const dueDate = new Date(trx.endDate);

  let lateDays = 0;

  if (actualReturnDate > dueDate) {
    lateDays = Math.ceil(
      (actualReturnDate - dueDate) /
        (1000 * 60 * 60 * 24)
    );
  }

  const lateFine =
    lateDays * DAILY_LATE_FINE;

  const damageFine =
    Number(data.damageFine) || 0;

  const grandTotal =
    trx.totalCost +
    lateFine +
    damageFine;

  const updatedTransaction =
    await prisma.transaction.update({
      where: {
        id: transactionId,
      },
      data: {
        actualReturnDate,
        lateFine,
        damageFine,
        grandTotal,
        transactionStatus: "COMPLETED",
      },
    });

  await prisma.asset.update({
    where: {
      id: trx.assetId,
    },
    data: {
      stock: {
        increment: trx.quantity,
      },
    },
  });

  return updatedTransaction;
};

// =========================
// PAYMENT
// =========================
const processPayment = async (
  transactionId,
  data
) => {
  const trx =
    await prisma.transaction.findUnique({
      where: {
        id: transactionId,
      },
    });

  if (!trx) {
    throw new Error(
      "Transaksi tidak ditemukan"
    );
  }

  const updatedTransaction =
    await prisma.transaction.update({
      where: {
        id: transactionId,
      },
      data: {
        paymentMethod: data.paymentMethod,
        paymentStatus: "SUCCESS",
        paidAmount: trx.totalCost,
        paymentTime: new Date(),
      },
    });

  return updatedTransaction;
};

module.exports = {
  getAllTransactions,
  getTransactionById,
  createTransaction,
  processReturn,
  processPayment,
};