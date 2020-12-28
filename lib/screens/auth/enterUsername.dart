import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:eva/config.dart';
import 'package:eva/services/firebaseAuth.dart';

class EnterUsernameScreen extends StatefulWidget {
  final currentUsername;
  final successPushName;

  EnterUsernameScreen({Key key, this.currentUsername, this.successPushName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnterUsernameScreenState();
}

class _EnterUsernameScreenState extends State<EnterUsernameScreen> {
  TextEditingController _usernameController = TextEditingController();

  String validationFiledText = '';

  Future<int> _postProfileData(String url, String body) async {
    try {
      var response = await http.post(url, body: body);
      print("Response status: ${response.statusCode}");
      Navigator.pushReplacementNamed(context, widget.successPushName);
    } catch (error) {
      setState(() {
        validationFiledText = 'invalid username';
      });
    }
  }

  void _sendUsername() async {
    setState(() {
      validationFiledText = '';
    });
    var valid = validationUsername();
    if (!valid) {
      return;
    }
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['profile'] + '?idToken=${token}';
      print(url);
      var data = {
        'username': _usernameController.text,
      };
      _postProfileData(url, jsonEncode(data)).then((res) {
        print(res);
      });
    });
  }

  bool validationUsername() {
    if (_usernameController.text.length < 3) {
      setState(() {
        validationFiledText = 'at least 3 characters';
      });
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _usernameController.text = widget.currentUsername;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(44, 62, 80, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Username",
                style: TextStyle(fontSize: 66, color: Colors.white),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Enter your username",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _usernameController,
                maxLength: 15,
                style: TextStyle(fontSize: 19, color: Colors.white),
                decoration: InputDecoration(
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 19),
                    hintText: "",
                    counterText: "",
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: new BorderSide(color: Colors.white)),
                    enabledBorder: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: new BorderSide(color: Colors.white)),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: new BorderSide(color: Colors.white)),
                    labelText: "",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 20)),
                keyboardType: TextInputType.text,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      validationFiledText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ]),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: Color.fromRGBO(44, 62, 80, 1),
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    onPressed: () {
                      _sendUsername();
                    },
                    child: Text(
                      "save",
                      style: TextStyle(
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
