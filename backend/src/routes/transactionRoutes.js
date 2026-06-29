const express = require("express");
const router = express.Router();
const { authenticate } = require("../middleware/authMiddleware");

const {
  getAllTransactions,
  getTransactionById,
  createTransaction,
  processReturn,
  processPayment,
} = require("../controllers/transactionController");

// All transaction routes require authentication
router.use(authenticate);

router.get("/", getAllTransactions);
router.get("/:id", getTransactionById);
router.post("/", createTransaction);

// PAYMENT
router.put("/:id/pay", processPayment);

// RETURN
router.put("/:id/return", processReturn);

module.exports = router;
