const logisticsService = require('../services/logisticsService');
const { broadcast } = require('../utils/websocket');

const logisticsWebhook = async (req, res, next) => {
  try {
    const {
      tracking_number,
      status,
      latitude,
      longitude,
      notes,
    } = req.body;

    if (!tracking_number || !status) {
      return res.status(400).json({
        success: false,
        message: 'tracking_number dan status wajib diisi',
      });
    }

    const shipment = await logisticsService.processWebhook({
      trackingNumber: tracking_number,
      status,
      latitude,
      longitude,
      notes,
    });

    broadcast('LOGISTICS_UPDATE', {
      trackingNumber: tracking_number,
      status,
      latitude,
      longitude,
      notes,
    });

    return res.status(200).json({
      success: true,
      message: 'Update logistik berhasil diproses',
      data: shipment,
    });
  } catch (err) {
    next(err);
  }
};

module.exports = { logisticsWebhook };