import 'dart:io';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/models/myCurrentLocation.dart';
import 'package:eva/widgets/widgets.dart';

class PubPhotoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PubPhotoScreenState();
}

class _PubPhotoScreenState extends State<PubPhotoScreen> {
  //models
  var myCurrentLocationState;
  Position position;
  var description = '';

  TextEditingController _descriptionTextController;
  File _image;

  Future _getImageFromDevice(ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      _image = image;
      position = myCurrentLocationState.getMyCurrentLocation();
    });
  }

  void _upload() {
    if (_image == null) return;
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = 'http://192.168.0.105:8005/?idToken=${token}';
      var _position;
      _postImage(url, _image, _position).then((res) {
        print(res);
      });
    });
  }

  void descriptionSubmit(String value) {}

  Future<int> _postImage(url, image, _position) async{
    var request = http.MultipartRequest('POST', Uri.parse(url));
    print(_position);
    request.fields['key'] = 'value';
    request.fields['key'] = 'value';
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        _image.readAsBytesSync(),
        filename: _image.path.split("/").last
      )
    );
    var res = await request.send();
    return(res.statusCode);
  }

  @override
  void initState() {
    super.initState();
    _descriptionTextController = TextEditingController();
    _getImageFromDevice(ImageSource.camera);
  }
  
  @override
  Widget build(BuildContext context) {
    myCurrentLocationState = Provider.of<MyCurrentLocationModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: <Widget>[
              ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 150,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: _image == null
                                ? Text('No image selected.')
                                : Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(position != null ? "${position.longitude.toString()} ${position.latitude.toString()}" : 'no location'),
                InputWithLabelWidget(_descriptionTextController, descriptionSubmit, 33, "description", ""),
              ]
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Opacity(
                opacity: 0.9,
                child: FloatingActionButton(
                  backgroundColor: Colors.purple.shade500,
                  child: Icon(Icons.save),
                  elevation: 0.0,
                  mini: true,
                  heroTag: null,
                  onPressed: (){_upload();},
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              left: 150,
              child: Opacity(
                opacity: 0.9,
                child: FloatingActionButton(
                  backgroundColor: Colors.purple.shade500,
                  child: Icon(Icons.refresh),
                  elevation: 0.0,
                  mini: true,
                  heroTag: null,
                  onPressed: (){_getImageFromDevice(ImageSource.camera);},
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              left: 5,
              child: Opacity(
                opacity: 0.9,
                child: FloatingActionButton(
                  backgroundColor: Colors.purple.shade500,
                  child: Icon(Icons.arrow_back),
                  elevation: 0.0,
                  mini: true,
                  heroTag: null,
                  onPressed: (){Navigator.pop(context);},
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}