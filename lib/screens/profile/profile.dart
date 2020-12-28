import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:eva/screens/auth/enterUsername.dart';
import 'package:eva/config.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:eva/models/profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _instagramTextController =
      TextEditingController(text: '');

  String username = '';
  String phone = '';

  File _image;
  Image imageWidget;

  Profile profileData;

  void textSubmit(String value) {
    updateProfileData();
  }

  Column _bottomSheetPhotoSource() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('make photo'),
          onTap: () {
            _getImageFromDevice(ImageSource.camera);
          },
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('choose from gallery'),
          onTap: () {
            _getImageFromDevice(ImageSource.gallery);
          },
        )
      ],
    );
  }

  logout() async {
    await signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', ModalRoute.withName('/'));
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
                  // physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(44, 62, 80, 1),
                          borderRadius: new BorderRadius.only(
                            bottomLeft: const Radius.circular(20.0),
                            bottomRight: const Radius.circular(20.0),
                          )),
                      height: MediaQuery.of(context).size.width - 35,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 38,
                            left: 48,
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.width - 96.0,
                                width: MediaQuery.of(context).size.width - 96.0,
                                decoration: new BoxDecoration(
                                  color: Color.fromRGBO(44, 62, 80, 1),
                                  borderRadius: BorderRadius.circular(9999.0),
                                )),
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(
                                  50.0, 40.0, 50.0, 25.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9999.0),
                                child: imageWidget == null
                                    ? Image.network(
                                        'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
                                        fit: BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.width -
                                                100.0,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100.0,
                                      )
                                    : imageWidget,
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
                                  Icons.photo_camera,
                                  color: Colors.pink[600],
                                ),
                                onPressed: _getImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                      child: Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('username',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text(username),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  SizedBox(
                                    height: 18.0,
                                    width: 18.0,
                                    child: new IconButton(
                                        padding: new EdgeInsets.all(0.0),
                                        icon: new Icon(Icons.edit, size: 18.0),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EnterUsernameScreen(
                                                currentUsername: username,
                                                successPushName: '/profile',
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Divider(
                              height: 30,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('phone',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.phone),
                                  SizedBox(width: 30),
                                  Text(phone),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                              height: 30,
                              thickness: 1,
                              indent: 0,
                              endIndent: 0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('instagram',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.instagram),
                                  SizedBox(width: 30),
                                  Expanded(
                                    child: InputWithStaticTextWidget(
                                        _instagramTextController,
                                        textSubmit,
                                        20,
                                        "instagram.com/",
                                        "username"),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          OutlineButton(
                              onPressed: () {
                                logout();
                              },
                              child: const Text('Log out',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(44, 62, 80, 1))),
                              borderSide: BorderSide(
                                  width: 1.0,
                                  color: Color.fromRGBO(44, 62, 80, 1)),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              )),
                          SizedBox(height: 50),
                        ],
                      ),
                    )
                  ]),
            ],
          ),
        ));
  }

  // get profile data

  Future<http.Response> _getProfileData(url) async {
    var res = await http.get(url);
    return res;
  }

  void getProfileData() async {
    String token;
    print("GET");
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['profile'] + '?idToken=${token}';
      _getProfileData(url).then((res) {
        if (res.body != null && res.body != 'null') {
          profileData =
              Profile.fromJson(json.decode(utf8.decode(res.bodyBytes)));
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
            height: MediaQuery.of(context).size.width - 100.0,
            width: MediaQuery.of(context).size.width - 100.0,
          );
        }
        profileData.username != null
            ? username = profileData.username
            : () {}();

        profileData.phone != null ? phone = profileData.phone : () {}();

        profileData.insta != ''
            ? _instagramTextController.text = profileData.insta
            : () {}();
      });
    }
  }

  //--------------

  // get and post new image

  Future _getImageFromDevice(ImageSource imageSource) async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      _image = image;
      imageWidget = Image.file(
        _image,
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.width - 100.0,
        width: MediaQuery.of(context).size.width - 100.0,
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

  Future<int> _postImage(url, image) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile.fromBytes(
        'file', _image.readAsBytesSync(),
        filename: _image.path.split("/").last));
    var res = await request.send();
    return (res.statusCode);
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
                )),
          );
        });
  }

  // -------------

  // update profile data

  Future<int> _postProfileData(String url, String body) async {
    try {
      var response = await http.post(url, body: body);
      print("Response status: ${response.statusCode}");
      return (response.statusCode);
    } catch (error) {
      print(error);
      return 500;
    }
  }

  void updateProfileData() async {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['profile'] + '/?idToken=${token}';
      print(url);
      var data = {'username': username, 'insta': _instagramTextController.text};
      _postProfileData(url, jsonEncode(data)).then((res) {
        print(res);
      });
    });
  }
}
