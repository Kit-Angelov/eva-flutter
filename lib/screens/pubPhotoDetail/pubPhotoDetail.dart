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
      getAuthor();
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
                              bottomLeft: const Radius.circular(40.0),
                              bottomRight: const Radius.circular(40.0),
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
                            color: Colors.pink[600],
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: [
                              Text(getDateString()),
                              Expanded(child: SizedBox()),
                              Icon(Icons.favorite),
                              Text(photoData.favorites?.length.toString()),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.remove_red_eye),
                              Text(photoData.views.toString())
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          photoData.title,
                          textAlign: TextAlign.start,
                        ),
                        Divider(
                            height: 20, thickness: 1, indent: 0, endIndent: 0),
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
                            Text(authorData == null ? '' : authorData.username)
                          ],
                        )),
                        Divider(
                            height: 20, thickness: 1, indent: 0, endIndent: 0),
                        Text(photoData.description),
                        SizedBox(
                          height: 20,
                        )
                      ]))
            ],
          ),
        ));
  }
  // get profile data

  Future<http.Response> _getAuthor(url) async {
    var res = await http.get(url);
    print(res.body);
    return res;
  }

  void getAuthor() async {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['user'] +
          '?idToken=${token}' +
          '&userId=${photoData.userId}';
      _getAuthor(url).then((res) {
        if (res.body != null && res.body != 'null') {
          setState(() {
            authorData =
                Profile.fromJson(json.decode(utf8.decode(res.bodyBytes)));
          });
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
    var dateTime = DateTime.fromMillisecondsSinceEpoch(photoData.date * 1000);
    var dateTimeUTC = DateTime.utc(dateTime.year, dateTime.month, dateTime.day,
        dateTime.hour, dateTime.minute);
    print(dateTimeUTC.isUtc);
    var dateTimeLocal = dateTimeUTC.toLocal();
    return "${dateTimeLocal.hour.toString()}:${dateTimeLocal.minute.toString()} ${dateTimeLocal.day.toString()}/${dateTimeLocal.month.toString()}/${dateTimeLocal.year.toString()}";
  }
}
