import 'package:flutter/material.dart';

class GetPhotoModel extends ChangeNotifier{
  bool widgetOpenFlag = false;

  void setWidgetOpenFlag(bool value) {
    widgetOpenFlag = value;
    notifyListeners();
  }

  bool getWidgetOpenFlag() {
    return widgetOpenFlag;
  }
}