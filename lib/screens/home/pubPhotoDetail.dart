import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/models/photoData.dart';
import 'package:eva/models/photoPost.dart';
import 'package:eva/config.dart';

class PubPhotoDetailScreen extends StatefulWidget {
  final Map photoData;
  final closeCallback;

  PubPhotoDetailScreen({Key key, this.photoData, this.closeCallback})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _PubPhotoDetailScreenState();
}

class _PubPhotoDetailScreenState extends State<PubPhotoDetailScreen> {
  var photoData;
  PhotoPost authorData;

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
    print(photoData);
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
                                  photoData['imagesPaths'] +
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
                          Text('11.03.2021'),
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
                          'Title of the photo',
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
                            // child: profileData != null
                            //     ? profileData.photo != ''
                            //         ? Image.network(
                            //             profileData.photo + '/300.jpg',
                            //             fit: BoxFit.cover,
                            //           )
                            //         : Image.network(
                            //             'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
                            //             fit: BoxFit.cover,
                            //           )
                            //     : Image.network(
                            //         'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
                            //         fit: BoxFit.cover,
                            //       )
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
                        children: [
                          Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
                        ],
                      ),
                    )
                  ]))
            ],
          ),
        ));
  }
  // get profile data

  Future<http.Response> _getAuthorData(url) async {
    var res = await http.get(url);
    return res;
  }

  void getAuthorData() async {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['user'] +
          '/?idToken=${token}' +
          '&userId=${photoData.userId}';
      _getAuthorData(url).then((res) {
        if (res.body != null && res.body != 'null') {
          print(res.body);
          authorData = PhotoPost.fromJson(json.decode(res.body));
        }
      });
    });
  }
}
