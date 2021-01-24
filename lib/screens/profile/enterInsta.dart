import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:eva/config.dart';
import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/widgets/widgets.dart';

class EnterInstaScreen extends StatefulWidget {
  final currentUsername;
  final currentInsta;
  final successPushInsta;

  EnterInstaScreen(
      {Key key, this.currentUsername, this.currentInsta, this.successPushInsta})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EnterInstaScreenState();
}

class _EnterInstaScreenState extends State<EnterInstaScreen> {
  TextEditingController _instaController = TextEditingController();

  String validationFiledText = '';

  Future<int> _postProfileData(String url, String body) async {
    showWaitDialog(context);
    try {
      var response = await http.post(url, body: body);
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, widget.successPushInsta);
    } catch (error) {
      Navigator.pop(context);
      setState(() {
        validationFiledText = 'invalid link';
      });
    }
  }

  void _sendUsername() async {
    setState(() {
      validationFiledText = '';
    });
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['profile'] + '?idToken=${token}';
      var data = {
        'username': widget.currentUsername,
        'insta': _instaController.text,
      };
      _postProfileData(url, jsonEncode(data)).then((res) {});
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _instaController.text = widget.currentInsta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color.fromRGBO(44, 62, 80, 1),
        body: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Instagram link",
                    style: TextStyle(fontSize: 66, color: Colors.white),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Enter instagram link",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'instagram.com/',
                        style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _instaController,
                          maxLength: 15,
                          style: TextStyle(fontSize: 19, color: Colors.white),
                          decoration: InputDecoration(
                              prefixStyle:
                                  TextStyle(color: Colors.white, fontSize: 19),
                              hintText: "",
                              counterText: "",
                              border: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  borderSide:
                                      new BorderSide(color: Colors.white)),
                              enabledBorder: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  borderSide:
                                      new BorderSide(color: Colors.white)),
                              focusedBorder: new OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  borderSide:
                                      new BorderSide(color: Colors.white)),
                              labelText: "",
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20)),
                          keyboardType: TextInputType.text,
                        ),
                      )
                    ],
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
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
          ],
        ));
  }
}
