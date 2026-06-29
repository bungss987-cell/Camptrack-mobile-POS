const shipmentService = require('../services/shipmentService');

const createShipment = async (req, res, next) => {
  try {
    const {
      transactionId,
      courierName,
      recipientName,
      recipientPhone,
      deliveryAddress,
      shippingCost,
    } = req.body;

    if (!transactionId || !recipientName || !deliveryAddress) {
      return res.status(400).json({
        success: false,
        message:
          'Field transactionId, recipientName, dan deliveryAddress wajib diisi',
      });
    }

    const shipment = await shipmentService.createShipment({
      transactionId: parseInt(transactionId),
      courierName: courierName || 'JNE',
      recipientName,
      recipientPhone,
      deliveryAddress,
      shippingCost: parseInt(shippingCost) || 0,
    });

    return res.status(201).json({
      success: true,
      message: 'Kurir berhasil dipanggil. Shipment dibuat.',
      data: shipment,
    });
  } catch (err) {
    next(err);
  }
};

const getShipment = async (req, res, next) => {
  try {
    const { trackingNumber } = req.params;

    const shipment =
      await shipmentService.getShipmentByTracking(
        trackingNumber
      );

    return res.status(200).json({
      success: true,
      data: shipment,
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  createShipment,
  getShipment,
};