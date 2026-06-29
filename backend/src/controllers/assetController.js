const assetService = require('../services/assetService');

const getAllAssets = async (req, res, next) => {
  try {
    const assets = await assetService.getAllAssets();

    return res.status(200).json({
      success: true,
      data: assets,
    });
  } catch (err) {
    next(err);
  }
};

const getAssetById = async (req, res, next) => {
  try {
    const asset = await assetService.getAssetById(
      parseInt(req.params.id)
    );

    return res.status(200).json({
      success: true,
      data: asset,
    });
  } catch (err) {
    next(err);
  }
};

const createAsset = async (req, res, next) => {
  try {
    const asset = await assetService.createAsset(req.body);

    return res.status(201).json({
      success: true,
      message: 'Aset berhasil ditambahkan',
      data: asset,
    });
  } catch (err) {
    next(err);
  }
};

const updateAsset = async (req, res, next) => {
  try {
    const asset = await assetService.updateAsset(
      parseInt(req.params.id),
      req.body
    );

    return res.status(200).json({
      success: true,
      message: 'Aset berhasil diperbarui',
      data: asset,
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getAllAssets,
  getAssetById,
  createAsset,
  updateAsset,
};