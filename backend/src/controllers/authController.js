const authService = require('../services/authService');

const register = async (req, res, next) => {
  try {
    const { name, email, password, phone, address } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Nama, email, dan password wajib diisi',
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        success: false,
        message: 'Password minimal 6 karakter',
      });
    }

    const result = await authService.register({
      name,
      email,
      password,
      phone,
      address,
    });

    return res.status(201).json({
      success: true,
      message: 'Registrasi berhasil',
      data: result,
    });
  } catch (err) {
    next(err);
  }
};

const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Email dan password wajib diisi',
      });
    }

    const result = await authService.login({ email, password });

    return res.status(200).json({
      success: true,
      message: 'Login berhasil',
      data: result,
    });
  } catch (err) {
    next(err);
  }
};

const getProfile = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const profile = await authService.getProfile(userId);

    return res.status(200).json({
      success: true,
      data: profile,
    });
  } catch (err) {
    next(err);
  }
};

const updateProfile = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const { name, email, phone, address } = req.body;

    const profile = await authService.updateProfile(userId, {
      name,
      email,
      phone,
      address,
    });

    return res.status(200).json({
      success: true,
      message: 'Profil berhasil diperbarui',
      data: profile,
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  register,
  login,
  getProfile,
  updateProfile,
};
