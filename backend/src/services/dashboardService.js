const prisma = require('../config/database');

const getDashboardStats = async () => {
  const totalAssets = await prisma.asset.count();

  const availableAssets = await prisma.asset.count({
    where: {
      status: 'AVAILABLE',
    },
  });

  const rentedAssets = await prisma.asset.count({
    where: {
      status: 'RENTED',
    },
  });

  const damagedAssets = await prisma.asset.count({
    where: {
      status: 'DAMAGED',
    },
  });

  const totalTransactions =
    await prisma.transaction.count();

  const monthlyRevenue =
    await prisma.transaction.aggregate({
      _sum: {
        grandTotal: true,
      },
    });

  return {
    totalAssets,
    availableAssets,
    rentedAssets,
    damagedAssets,
    totalTransactions,
    monthlyRevenue:
      monthlyRevenue._sum.grandTotal || 0,
  };
};

module.exports = {
  getDashboardStats,
};