const { WebSocketServer } = require('ws');

let wss = null;
const clients = new Set();

const initWebSocket = () => {
  const WS_PORT = process.env.WS_PORT || 3001;
  wss = new WebSocketServer({ port: WS_PORT });

  wss.on('connection', (ws) => {
    clients.add(ws);
    console.log(`WebSocket client terhubung. Total: ${clients.size}`);

    ws.on('close', () => {
      clients.delete(ws);
      console.log(`WebSocket client terputus. Total: ${clients.size}`);
    });

    ws.on('error', (err) => {
      console.error('[WS Error]', err.message);
      clients.delete(ws);
    });

    ws.send(JSON.stringify({ 
      type: 'CONNECTED', 
      message: 'CampTrack WebSocket aktif' 
    }));
  });

  console.log(`WebSocket Server berjalan di ws://localhost:${WS_PORT}`);
};

const broadcast = (type, payload) => {
  const message = JSON.stringify({ 
    type, 
    payload, 
    timestamp: new Date().toISOString() 
  });

  clients.forEach((client) => {
    if (client.readyState === 1) {
      client.send(message);
    }
  });

  console.log(`Broadcast [${type}] ke ${clients.size} client`);
};

module.exports = { initWebSocket, broadcast };