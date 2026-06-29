const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'camptrack_secret_key_2024';

const authenticate = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      message: 'Token tidak ditemukan. Silakan login terlebih dahulu.',
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        message: 'Token sudah expired. Silakan login ulang.',
      });
    }

    return res.status(401).json({
      success: false,
      message: 'Token tidak valid.',
    });
  }
};

module.exports = { authenticate };
