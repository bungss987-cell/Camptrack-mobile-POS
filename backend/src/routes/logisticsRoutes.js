const express = require('express');
const router = express.Router();
const { logisticsWebhook } = require('../controllers/logisticsController');

router.post('/webhook', logisticsWebhook);

module.exports = router;