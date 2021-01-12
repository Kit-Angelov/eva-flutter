import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:eva/config.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:eva/services/firebaseAuth.dart';

class PubPhotoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PubPhotoScreenState();
}

class _PubPhotoScreenState extends State<PubPhotoScreen> {
  bool load = false;
  TextEditingController _photoTitleTextController =
      TextEditingController(text: '');
  TextEditingController _photoDescriptionTextController =
      TextEditingController(text: '');
  LatLng latlng;

  File _image;

  Future<LatLng> getLastKnownLocation() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      return LatLng(position.latitude, position.longitude);
    } else {
      Geolocator geolocator = Geolocator();
      Position position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    }
  }

  Future _getImageFromDevice(ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);
    if (image == null) {
      Navigator.pop(context);
    }
    latlng = await getLastKnownLocation();
    setState(() {
      _image = image;
      load = true;
    });
  }

  void _upload(BuildContext context) {
    if (_image == null) return;
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['pubPhoto'] + '?idToken=${token}';
      _postImage(url, _image).then((res) {
        print(res);
        showAlertDialog(context, 'Success', 'Photo is publish', 'ok');
      }).catchError((error) {
        print(error);
        showAlertDialog(context, 'Fault', "Photo is't publish", 'ok');
      });
    });
  }

  void descriptionSubmit(String value) {}

  Future<int> _postImage(url, image) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['latitude'] = latlng.latitude.toString();
    request.fields['longitude'] = latlng.longitude.toString();
    request.fields['description'] = _photoDescriptionTextController.text;
    request.fields['title'] = _photoTitleTextController.text;
    request.files.add(http.MultipartFile.fromBytes(
        'file', _image.readAsBytesSync(),
        filename: _image.path.split("/").last));
    var res = await request.send();
    return (res.statusCode);
  }

  @override
  void initState() {
    super.initState();
    _photoTitleTextController = TextEditingController();
    _photoDescriptionTextController = TextEditingController();
    _getImageFromDevice(ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return load == false
        ? LoadWidget()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(44, 62, 80, 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(40),
                            bottomRight: const Radius.circular(40),
                          )),
                      child: Stack(
                        children: [
                          Positioned(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              color: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.only(
                                  bottomLeft: const Radius.circular(40.0),
                                  bottomRight: const Radius.circular(40.0),
                                ),
                                child: _image == null
                                    ? SizedBox()
                                    : Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      ),
                              )),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.pink[600], width: 1),
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.pink[600],
                                ),
                                onPressed: () {
                                  _getImageFromDevice(ImageSource.camera);
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        InputWithLabelWidget(_photoTitleTextController,
                            (e) => {}, 15, "Title", "Enter title"),
                        Divider(
                            height: 20, thickness: 1, indent: 0, endIndent: 0),
                        InputWithLabelMultilineWidget(
                            _photoDescriptionTextController,
                            (e) => {},
                            2000,
                            "Description",
                            "Enter description"),
                        Divider(
                            height: 20, thickness: 1, indent: 0, endIndent: 0),
                        SizedBox(
                          height: 20,
                        ),
                        OutlineButton(
                            onPressed: () {
                              _upload(context);
                            },
                            child: const Text('Publish',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(44, 62, 80, 1))),
                            borderSide: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(44, 62, 80, 1)),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            )),
                      ]))
                ],
              ),
            ));
  }

  showAlertDialog(
      BuildContext context, String title, String content, String buttonText) {
    Widget ok = FlatButton(
      child: Text(buttonText),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ok,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
