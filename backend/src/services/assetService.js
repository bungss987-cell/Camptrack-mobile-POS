const prisma = require('../config/database');

const getAllAssets = async () => {
  return await prisma.asset.findMany({
    orderBy: {
      id: 'desc',
    },
  });
};

const getAssetById = async (id) => {
  const asset = await prisma.asset.findUnique({
    where: { id },
  });

  if (!asset) {
    const error = new Error('Aset tidak ditemukan');
    error.statusCode = 404;
    throw error;
  }

  return asset;
};

const createAsset = async (data) => {
  return await prisma.asset.create({
    data: {
      name: data.name,
      description: data.description,
      stock: Number(data.stock),
      rentalPrice: Number(data.rentalPrice),
      status: data.status || 'AVAILABLE',
    },
  });
};

const updateAsset = async (id, data) => {
  return await prisma.asset.update({
    where: { id },
    data: {
      name: data.name,
      description: data.description,
      stock: data.stock ? Number(data.stock) : undefined,
      rentalPrice: data.rentalPrice
        ? Number(data.rentalPrice)
        : undefined,
      status: data.status,
    },
  });
};

module.exports = {
  getAllAssets,
  getAssetById,
  createAsset,
  updateAsset,
};