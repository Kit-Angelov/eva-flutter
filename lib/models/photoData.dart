import 'package:flutter/material.dart';
import 'package:eva/models/photoPost.dart';

class PhotoDataModel extends ChangeNotifier {
  PhotoPost photoData;

  void setPhotoData(PhotoPost data) {
    photoData = data;
    notifyListeners();
  }

  PhotoPost getPhotoData() {
    return photoData;
  }
}
