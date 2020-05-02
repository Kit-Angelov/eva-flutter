import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eva/services/firebaseAuth.dart';

class GetPhotoWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GetPhotoWidgetState();
}

class _GetPhotoWidgetState extends State<GetPhotoWidget> {

  File _image;

  Future _getImageFromDevice(ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      _image = image;
    });
  }

  Future<void> _upload() async{
    if (_image == null) return;
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = 'http://192.168.0.105:8005/?idToken=${token}';
      _postImage(url, _image);
    });
  }

  Future<void> _postImage(url, image) async{
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        _image.readAsBytesSync(),
        filename: _image.path.split("/").last
      )
    );
    var res = await request.send();
    print(res.statusCode);
  }


  @override
  void initState() {
    super.initState();
    _getImageFromDevice(ImageSource.camera);
  }
  
  @override
  Widget build(BuildContext context) {
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
                  height: MediaQuery.of(context).size.height,
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