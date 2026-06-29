const express = require('express');
const router = express.Router();
const { createShipment, getShipment } = require('../controllers/shipmentController');

router.post('/', createShipment);
router.get('/:trackingNumber', getShipment);

module.exports = router;