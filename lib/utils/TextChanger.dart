import 'package:flutter/foundation.dart';

class TextChanger with ChangeNotifier, DiagnosticableTreeMixin {
  String _addOrder = "";

  String get addOrder => _addOrder;

  void setAddOrder(String data) {
    _addOrder = data;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('addOrder', addOrder));
  }

}