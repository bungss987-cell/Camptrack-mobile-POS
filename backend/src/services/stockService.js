const prisma = require('../config/database');

const checkStock = async (assetId) => {
  const asset = await prisma.asset.findUnique({
    where: {
      id: assetId,
    },
  });

  if (!asset) {
    const error = new Error('Aset tidak ditemukan');
    error.statusCode = 404;
    throw error;
  }

  return {
    item_id: asset.id,
    item_name: asset.name,
    available_stock: asset.stock,
  };
};

module.exports = {
  checkStock,
};