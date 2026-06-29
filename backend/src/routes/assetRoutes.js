const express = require('express');
const router = express.Router();
const { getAllAssets, getAssetById, createAsset, updateAsset } = require('../controllers/assetController');

router.get('/', getAllAssets);
router.get('/:id', getAssetById);
router.post('/', createAsset);
router.put('/:id', updateAsset);

module.exports = router;