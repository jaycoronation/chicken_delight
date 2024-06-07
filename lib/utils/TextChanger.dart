import 'package:flutter/foundation.dart';

class TextChanger with ChangeNotifier, DiagnosticableTreeMixin {
  String _addOrder = "";
  String _addProduct = "";
  String _refreshProductList = "";

  String get addOrder => _addOrder;
  String get addProduct => _addProduct;
  String get refreshProductList => _refreshProductList;

  void setAddOrder(String data) {
    _addOrder = data;
    notifyListeners();
  }

  void setProduct(String data) {
    _addProduct = data;
    notifyListeners();
  }

  void refreshProduct(String data) {
    _refreshProductList = data;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('addOrder', addOrder));
    properties.add(StringProperty('addProduct', addOrder));
    properties.add(StringProperty('refreshProduct', addOrder));
  }

}