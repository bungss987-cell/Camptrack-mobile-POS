const prisma = require('../config/database');

const processWebhook = async ({
  trackingNumber,
  status,
  latitude,
  longitude,
  notes,
}) => {
  const shipment = await prisma.shipment.update({
    where: {
      trackingNumber,
    },
    data: {
      status,
      latitude: latitude ? Number(latitude) : null,
      longitude: longitude ? Number(longitude) : null,
      notes,
      updatedAt: new Date(),
    },
  });

  return shipment;
};

module.exports = {
  processWebhook,
};