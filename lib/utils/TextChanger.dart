import 'package:flutter/foundation.dart';

class TextChanger with ChangeNotifier, DiagnosticableTreeMixin {
  String _updateCounter = "";

  String get updateCounter => _updateCounter;

  void setUpdateCounter(String data) {
    _updateCounter = data;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('updateCounter', updateCounter));
  }
}