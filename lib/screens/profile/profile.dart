import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:eva/screens/profile/enterUsername.dart';
import 'package:eva/screens/profile/enterInsta.dart';
import 'package:eva/config.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:eva/models/profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool load = false;
  String username = '';
  String instagram = '';
  String phone = '';

  File _image;
  Image profilePhoto;

  Profile profileData;

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
    return load == false
        ? LoadWidget()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Stack(
                children: <Widget>[
                  ListView(padding: const EdgeInsets.all(0), children: <Widget>[
                    Container(
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(44, 62, 80, 1),
                          borderRadius: new BorderRadius.only(
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
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
                                child: profilePhoto == null
                                    ? LogoBlankWidget(
                                        MediaQuery.of(context).size.width - 100,
                                        MediaQuery.of(context).size.width - 100,
                                      )
                                    : profilePhoto,
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
                                    height: 20.0,
                                    width: 20.0,
                                    child: new IconButton(
                                        padding: new EdgeInsets.all(0.0),
                                        icon: new Icon(Icons.edit, size: 20.0),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EnterUsernameScreen(
                                                currentUsername: username,
                                                currentInsta: instagram,
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
                                  SizedBox(width: 20),
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
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.instagram),
                                  SizedBox(width: 20),
                                  Text("instagram.com/" + instagram),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: new IconButton(
                                        padding: new EdgeInsets.all(0.0),
                                        icon: new Icon(Icons.edit, size: 20.0),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EnterInstaScreen(
                                                currentUsername: username,
                                                currentInsta: instagram,
                                                successPushInsta: '/profile',
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          OutlineButton(
                              onPressed: () {
                                showLogoutAlertDialog(context);
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
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            child: Text(
                              'Delete account',
                              style: TextStyle(color: Colors.pink[600]),
                            ),
                            onPressed: () {
                              showDeleteAlertDialog(context);
                            },
                          ),
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
          profilePhoto = Image.network(
            config.urls['media'] + profileData.photo + '/300.jpg',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.width - 100.0,
            width: MediaQuery.of(context).size.width - 100.0,
          );
        }
        profileData.username != null
            ? username = profileData.username
            : () {}();

        profileData.phone != null ? phone = profileData.phone : () {}();

        profileData.insta != '' ? instagram = profileData.insta : () {}();
        load = true;
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
      profilePhoto = Image.file(
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
      var url = config.urls['profilePhoto'] + '?idToken=${token}';
      _postImage(url, _image).then((res) {});
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

  // logout

  showLogoutAlertDialog(BuildContext context) {
    Widget ok = FlatButton(
      child: Text(
        'logout',
        style: TextStyle(color: Colors.pink[600]),
      ),
      onPressed: () {
        logout();
      },
    );
    Widget cancel = FlatButton(
      child: Text('cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Logout'),
      content: Text('Do you really want to leave'),
      actions: [ok, cancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // delete account

  Future<http.Response> _deleteAccount(url) async {
    var res = await http.get(url);
    return res;
  }

  void deleteAccount() async {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['deleteProfile'] + '?idToken=${token}';
      _deleteAccount(url).then((res) {
        logout();
      }).catchError((error) {});
    });
  }

  showDeleteAlertDialog(BuildContext context) {
    Widget ok = FlatButton(
      child: Text(
        'delete',
        style: TextStyle(color: Colors.pink[600]),
      ),
      onPressed: () {
        deleteAccount();
      },
    );
    Widget cancel = FlatButton(
      child: Text('cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Deleting account'),
      content: Text('Are you sure you want to delete account'),
      actions: [ok, cancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // --------------
}
