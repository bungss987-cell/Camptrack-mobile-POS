const transactionService = require("../services/transactionService");

const getAllTransactions = async (req, res, next) => {
  try {
    const transactions =
      await transactionService.getAllTransactions();

    return res.status(200).json({
      success: true,
      data: transactions,
    });
  } catch (err) {
    next(err);
  }
};

const getTransactionById = async (req, res, next) => {
  try {
    const transaction =
      await transactionService.getTransactionById(
        parseInt(req.params.id)
      );

    return res.status(200).json({
      success: true,
      data: transaction,
    });
  } catch (err) {
    next(err);
  }
};

const createTransaction = async (req, res, next) => {
  try {
    const userId = req.user.userId;

    const transaction =
      await transactionService.createTransaction(
        req.body,
        userId
      );

    return res.status(201).json({
      success: true,
      message: "Peminjaman berhasil dibuat",
      data: transaction,
    });
  } catch (err) {
    next(err);
  }
};

const processReturn = async (req, res, next) => {
  try {
    const { actualReturnDate, damageFine } =
      req.body;

    const result =
      await transactionService.processReturn(
        parseInt(req.params.id),
        {
          actualReturnDate,
          damageFine:
            parseInt(damageFine) || 0,
        }
      );

    return res.status(200).json({
      success: true,
      message:
        "Pengembalian berhasil diproses",
      data: result,
    });
  } catch (err) {
    next(err);
  }
};

// ===========================
// PAYMENT
// ===========================
const processPayment = async (req, res, next) => {
  try {
    const { paymentMethod } = req.body;

    const result = await transactionService.processPayment(
      parseInt(req.params.id),
      {
        paymentMethod,
      }
    );

    return res.status(200).json({
      success: true,
      message: "Pembayaran berhasil",
      data: result,
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getAllTransactions,
  getTransactionById,
  createTransaction,
  processReturn,
  processPayment,
};