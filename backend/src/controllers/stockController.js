const stockService = require('../services/stockService');

const getStock = async (req, res, next) => {
  try {
    const { id } = req.params;
    const stockData = await stockService.checkStock(parseInt(id));

    return res.status(200).json({
      success: true,
      data: stockData,
    });
  } catch (err) {
    next(err);
  }
};

module.exports = { getStock };