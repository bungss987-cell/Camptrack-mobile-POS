require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { createServer } = require('http');
const { initWebSocket } = require('./utils/websocket');
const errorHandler = require('./middleware/errorHandler');

const authRoutes        = require('./routes/authRoutes');
const stockRoutes       = require('./routes/stockRoutes');
const shipmentRoutes    = require('./routes/shipmentRoutes');
const paymentRoutes     = require('./routes/paymentRoutes');
const logisticsRoutes   = require('./routes/logisticsRoutes');
const reportRoutes      = require('./routes/reportRoutes');
const assetRoutes       = require('./routes/assetRoutes');
const transactionRoutes = require('./routes/transactionRoutes');
const dashboardRoutes   = require('./routes/dashboardRoutes');

const app = express();
const httpServer = createServer(app);

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/auth',         authRoutes);
app.use('/api/stock',        stockRoutes);
app.use('/api/shipment',     shipmentRoutes);
app.use('/api/payment',      paymentRoutes);
app.use('/api/logistics',    logisticsRoutes);
app.use('/api/reports',      reportRoutes);
app.use('/api/assets',       assetRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/dashboard',    dashboardRoutes);

app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

app.use(errorHandler);

const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});

initWebSocket();

module.exports = app;