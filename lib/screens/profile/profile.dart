
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:eva/config.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:eva/models/profile.dart';


class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _usernameTextController = TextEditingController(text: 'initial text');
  TextEditingController _instagramTextController = TextEditingController(text: 'balexander64');
  TextEditingController _telegramTextController = TextEditingController(text: 'blinkcast');
  String phone = '';

  File _image;
  Image imageWidget;

  Profile profileData;

  void usernameSubmit(String value) {
    print(value);
  }
  void instagramSubmit(String value) {
    print(value);
  }
  void telegramSubmit(String value) {
    print(value);
  }

  Future _getImageFromDevice(ImageSource imageSource) async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      _image = image;
      imageWidget = Image.file(
        _image,
        fit: BoxFit.cover,
      );
      _upload();
    });
  }

  void _upload() {
    if (_image == null) return;
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['profilePhoto'] + '/?idToken=${token}';
      print(url);
      _postImage(url, _image).then((res) {
        print(res);
      });
    });
  }

  Future<int> _postImage(url, image) async{
    var request = http.MultipartRequest('POST', Uri.parse(url));
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

  void _getImage() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
      return Container(
        child: _bottomSheetPhotoSource(),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
          )
        ),
      );
    });
  }
  
  Column _bottomSheetPhotoSource() {
    return Column (
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('make photo'),
          onTap: (){_getImageFromDevice(ImageSource.camera);},
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('choose from gallery'),
          onTap: (){_getImageFromDevice(ImageSource.gallery);},
        )
      ],
    ); 
  }

  Future<http.Response> _getProfileData(url) async{
    var res = await http.get(url);
    return res;
  }

  void getProfileData() async{
    String token;
    print("GET");
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['profile'] + '/?idToken=${token}';
      _getProfileData(url).then((res) {
        if (res.body != null && res.body !='null') {
          print(res.body);
          profileData = Profile.fromJson(json.decode(res.body));
          fillProfileFields();
        }
      });
    });
  }

  void fillProfileFields() {
    if (profileData != null) {
      setState(() {
        if (profileData.photo != '') {
          imageWidget = Image.network(
            profileData.photo + '/300.jpg',
            fit: BoxFit.cover,
          );
        }
        if (profileData.username != '') {
          _usernameTextController.text = profileData.username;
        }
        if (profileData.phone != null) {
          if (profileData.phone.entity != '') {
            phone = profileData.phone.entity;
          }
        }
        if (profileData.social != null) {
          if (profileData.social.insta != null) {
            profileData.social.insta.entity != '' ? _instagramTextController.text = profileData.social.insta.entity : (){}();
          }
          if (profileData.social.tgrm != null) {
            profileData.social.tgrm.entity != '' ? _telegramTextController.text = profileData.social.tgrm.entity : (){}();
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
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
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: imageWidget == null
                                ? Image.network('https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg', fit: BoxFit.cover,)
                                : imageWidget,
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Opacity(
                          opacity: 0.8,
                          child: FloatingActionButton(
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.photo_camera),
                            elevation: 0.0,
                            mini: true,
                            onPressed: _getImage,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Column(
                    children: <Widget>[
                      InputWithLabelWidget(_usernameTextController, usernameSubmit, 15, "username", "username"),
                      Divider(height: 30, thickness: 1, indent: 0, endIndent: 0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'phone',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 10),
                          Row(children: <Widget>[
                            Icon(FontAwesomeIcons.phoneAlt),
                            SizedBox(width: 30),
                            Text(phone),
                          ],),
                          SizedBox(height: 10),
                          Row(children: <Widget>[
                            Expanded(
                              child: Text("visible to other users"),
                            ),
                            CupertinoSwitch(
                              value: true,
                              onChanged: (bool value) {}
                            ),
                          ],),
                        ],
                      ),
                      Divider(height: 30, thickness: 1, indent: 0, endIndent: 0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'instagram',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 10),
                          Row(children: <Widget>[
                            Icon(FontAwesomeIcons.instagram),
                            SizedBox(width: 30),
                            Expanded(
                              child: InputWithStaticTextWidget(_instagramTextController, instagramSubmit, 20, "instagram.com/", "username"),
                            )
                          ],),
                          SizedBox(height: 10),
                          Row(children: <Widget>[
                            Expanded(
                              child: Text("visible to other users"),
                            ),
                            CupertinoSwitch(
                              value: true,
                              onChanged: (bool value) {}
                            ),
                          ],),
                        ],
                      ),
                      Divider(height: 30, thickness: 1, indent: 0, endIndent: 0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'telegram',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 10),
                          Row(children: <Widget>[
                            Icon(FontAwesomeIcons.telegramPlane),
                            SizedBox(width: 30),
                            Expanded(
                              child: InputWithStaticTextWidget(_telegramTextController, telegramSubmit, 20, "t.me/", "username"),
                            )
                          ],),
                          SizedBox(height: 10),
                          Row(children: <Widget>[
                            Expanded(
                              child: Text("visible to other users"),
                            ),
                            CupertinoSwitch(
                              value: true,
                              onChanged: (bool value) {}
                            ),
                          ],),
                        ],
                      ),
                      Divider(height: 30, thickness: 1, indent: 0, endIndent: 0),
                      SizedBox(height: 50),
                    ],
                  ),
                )
              ]
            ),
            Positioned(
              bottom: 5,
              right: 5,
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