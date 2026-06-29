const prisma = require('../config/database');

const generateTrackingNumber = () => {
  return `CT-${Date.now()}`;
};

const createShipment = async (data) => {
  const shipment = await prisma.shipment.create({
    data: {
      transactionId: data.transactionId,
      trackingNumber: generateTrackingNumber(),
      courierName: data.courierName,
      recipientName: data.recipientName,
      recipientPhone: data.recipientPhone,
      deliveryAddress: data.deliveryAddress,
      shippingCost: data.shippingCost,
      status: 'PENDING',
    },
  });

  return shipment;
};

const getShipmentByTracking = async (trackingNumber) => {
  const shipment = await prisma.shipment.findUnique({
    where: {
      trackingNumber,
    },
  });

  if (!shipment) {
    const error = new Error('Data shipment tidak ditemukan');
    error.statusCode = 404;
    throw error;
  }

  return shipment;
};

module.exports = {
  createShipment,
  getShipmentByTracking,
};