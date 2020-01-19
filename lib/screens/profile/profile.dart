
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _usernameTextController;
  TextEditingController _instagramTextController;
  TextEditingController _telegramTextController;

  File _image;

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
    });
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

  @override
  void initState() {
    super.initState();
    _usernameTextController = TextEditingController(text: 'initial text');
    _instagramTextController = TextEditingController(text: 'balexander64');
    _telegramTextController = TextEditingController(text: 'blinkcast');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
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
                        Text("+79803404209"),
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
          ],
        )
      )
    );
  }
}