import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../services/asset_service.dart';

enum AssetState {
  idle,
  loading,
  loaded,
  error,
}

class AssetProvider extends ChangeNotifier {
  final AssetService _assetService = AssetService();

  AssetState _state = AssetState.idle;
  List<Asset> _assets = [];
  String _searchKeyword = '';
  String? _errorMessage;

  AssetState get state => _state;
  List<Asset> get assets => _assets;
  String? get errorMessage => _errorMessage;
  String get searchKeyword => _searchKeyword;

  List<Asset> get filteredAssets {
    if (_searchKeyword.isEmpty) return _assets;
    return _assets
        .where((a) =>
            a.name.toLowerCase().contains(_searchKeyword.toLowerCase()))
        .toList();
  }

  /// Fetch all assets
  Future<void> fetchAssets() async {
    _state = AssetState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _assets = await _assetService.getAssets();
      _state = AssetState.loaded;
    } catch (e) {
      _state = AssetState.error;
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    }

    notifyListeners();
  }

  /// Update search keyword
  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  /// Refresh assets
  Future<void> refresh() async {
    await fetchAssets();
  }
}
