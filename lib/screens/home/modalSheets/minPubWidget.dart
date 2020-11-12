import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/config.dart';
import 'package:eva/models/profile.dart';

class MinPubWidget extends StatefulWidget {
  final Map photoData;
  final closeCallback;
  final showUserDetailCallback;

  MinPubWidget(
      {Key key,
      this.photoData,
      this.closeCallback,
      this.showUserDetailCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MinPubWidgetState();
}

class MinPubWidgetState extends State<MinPubWidget> {
  var currentWidget;

  @override
  void initState() {
    super.initState();
    getUserData();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant MinPubWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      left: 5,
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  config.urls['media'] +
                      widget.photoData['imagesPaths'] +
                      '/300.jpg',
                  fit: BoxFit.cover,
                )),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Color.fromRGBO(44, 62, 80, 0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 14.0,
                  color: Color.fromRGBO(44, 62, 80, 1),
                ),
                onPressed: () {
                  widget.closeCallback();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Profile userData;

  Future<http.Response> _getUserData(url) async {
    var res = await http.get(url);
    return res;
  }

  void getUserData() async {
    String token;
    print("GET");
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['user'] +
          '/?idToken=${token}&userId=${widget.photoData['userId']}';
      _getUserData(url).then((res) {
        if (res.body != null && res.body != 'null') {
          print(res.body);
          setState(() {
            userData = Profile.fromJson(json.decode(res.body));
          });
        }
      });
    });
  }
}
