

import 'package:flutter/cupertino.dart';

class TestModel extends ChangeNotifier{
  String username = '41414';

  void setUsername(String newUsername) {
    username = newUsername;
    notifyListeners();
  }

  String getUsername() {
    return username;
  }
}