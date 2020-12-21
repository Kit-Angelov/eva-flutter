import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/models/photoData.dart';
import 'package:eva/models/profile.dart';
import 'package:eva/config.dart';

class PubPhotoDetailScreen extends StatefulWidget {
  final closeCallback;

  PubPhotoDetailScreen({Key key, this.closeCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PubPhotoDetailScreenState();
}

class _PubPhotoDetailScreenState extends State<PubPhotoDetailScreen> {
  var photoData;
  Profile authorData;

  @override
  void initState() {
    super.initState();
    setState(() {
      getAuthorData();
    });
  }

  @override
  Widget build(BuildContext context) {
    photoData = Provider.of<PhotoDataModel>(context).getPhotoData();
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            borderRadius: new BorderRadius.only(
                              bottomLeft: const Radius.circular(20.0),
                              bottomRight: const Radius.circular(20.0),
                            ),
                            child: Image.network(
                              config.urls['media'] +
                                  photoData.imagesPaths +
                                  '/640.jpg',
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
                            border:
                                Border.all(color: Colors.pink[600], width: 1),
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.pink[600],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Column(children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          Text(getDateString()),
                          Expanded(child: SizedBox()),
                          Icon(Icons.favorite),
                          Text('10234'),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.remove_red_eye),
                          Text('234')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        child: Row(
                      children: [
                        Text(
                          photoData.title,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    )),
                    Divider(height: 20, thickness: 1, indent: 0, endIndent: 0),
                    Container(
                        child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(44, 62, 80, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Author Username")
                      ],
                    )),
                    Divider(height: 20, thickness: 1, indent: 0, endIndent: 0),
                    Container(
                      child: Column(
                        children: [Text(photoData.description)],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ]))
            ],
          ),
        ));
  }
  // get profile data

  Future<http.Response> _getAuthorData(url) async {
    var res = await http.get(url);
    print(res.body);
    return res;
  }

  void getAuthorData() async {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['user'] +
          '?idToken=${token}' +
          '&userId=${photoData.userId}';
      _getAuthorData(url).then((res) {
        if (res.body != null && res.body != 'null') {
          print(res.body);
          authorData = Profile.fromJson(json.decode(res.body));
        }
      }).catchError((e) {
        print(e);
      });
    });
  }

  getDateString() {
    if (photoData.date == null) {
      return "no date";
    }
    var date = DateTime.fromMicrosecondsSinceEpoch(photoData.date);
    return "${date.hour.toString()}:${date.minute.toString()} ${date.day.toString()}/${date.month.toString()}/${date.year.toString()}";
  }
}
