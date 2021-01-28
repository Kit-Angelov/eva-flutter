import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:eva/models/photoData.dart';
import 'package:eva/models/profile.dart';
import 'package:eva/models/photoPost.dart';
import 'package:eva/config.dart';

class PubPhotoDetailScreen extends StatefulWidget {
  final setFilterUserCallback;

  PubPhotoDetailScreen({Key key, this.setFilterUserCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PubPhotoDetailScreenState();
}

class _PubPhotoDetailScreenState extends State<PubPhotoDetailScreen> {
  bool load = false;
  bool like = false;
  bool myPost = false;
  bool authorDetail = false;
  PhotoPost photoData = PhotoPost();
  Profile authorData;

  @override
  void initState() {
    super.initState();
    setState(() {
      getDetailPhotoPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    photoData = Provider.of<PhotoDataModel>(context).getPhotoData();
    return load == false
        ? LoadWidget()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(44, 62, 80, 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(40),
                            bottomRight: const Radius.circular(40),
                          )),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 90,
                              height: 100,
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    "STRINGER",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 55),
                                  )),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 120),
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.only(
                                  bottomLeft: const Radius.circular(40.0),
                                  bottomRight: const Radius.circular(40.0),
                                ),
                                child: photoPost.imagesPaths == null
                                    ? SizedBox()
                                    : Image.network(
                                        config.urls['media'] +
                                            photoPost.imagesPaths +
                                            '/640.jpg',
                                        fit: BoxFit.cover,
                                      ),
                              )),
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
                                  Text(
                                    getDateString(),
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Expanded(child: SizedBox()),
                                  GestureDetector(
                                    child: Row(
                                      children: [
                                        Icon(
                                          like
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.pink[600],
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(photoPost?.favorites?.length
                                            .toString()),
                                      ],
                                    ),
                                    onTap: () {
                                      likePhotoPost();
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.remove_red_eye,
                                    color: Color.fromRGBO(44, 62, 80, 1),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(photoPost?.views.toString()),
                                  myPost
                                      ? SizedBox(
                                          width: 10,
                                        )
                                      : SizedBox(),
                                  myPost
                                      ? GestureDetector(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.menu,
                                                color: Color.fromRGBO(
                                                    44, 62, 80, 1),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            _showPubActions();
                                          },
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              photoPost?.title,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 18),
                            ),
                            Divider(
                                height: 20,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0),
                            Container(
                                child: Row(
                              children: [
                                Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(44, 62, 80, 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: authorData != null
                                            ? authorData.photo != ''
                                                ? Image.network(
                                                    config.urls['media'] +
                                                        authorData.photo +
                                                        '/300.jpg',
                                                    fit: BoxFit.cover,
                                                  )
                                                : LogoBlankWidget(36.0, 36.0)
                                            : LogoBlankWidget(36.0, 36.0))),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(authorData == null
                                    ? ''
                                    : authorData.username),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                IconButton(
                                    icon: Icon(Icons.more_vert),
                                    color: Color.fromRGBO(44, 62, 80, 1),
                                    onPressed: () {
                                      _moreAuthorOptions();
                                    })
                              ],
                            )),
                            Divider(
                                height: 20,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0),
                            Text(photoPost?.description),
                            SizedBox(
                              height: 20,
                            )
                          ]))
                ],
              ),
            ));
  }
  // get profile data

  Future<Response> _getAuthor(url) async {
    var res = await get(url);
    return res;
  }

  void getAuthor() async {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['user'] +
          '?idToken=${token}' +
          '&userId=${photoPost.userId}';
      _getAuthor(url).then((res) {
        if (res.body != null && res.body != 'null') {
          setState(() {
            authorData =
                Profile.fromJson(json.decode(utf8.decode(res.bodyBytes)));
            checkOwning();
          });
        }
      }).catchError((e) {});
    });
  }

  Column _bottomSheetAuthorOptions() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.filter),
          title: Text('Show all user posts'),
          onTap: () {
            widget.setFilterUserCallback(authorData);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        authorData != null
            ? authorData.insta != null
                ? ListTile(
                    leading: Icon(FontAwesomeIcons.instagram),
                    title: Text('Open instagram page'),
                    onTap: () {
                      launch('https://instagram.com/' + authorData.insta);
                    },
                  )
                : null
            : null
      ],
    );
  }

  void _moreAuthorOptions() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: _bottomSheetAuthorOptions(),
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

  //PhotoPost

  PhotoPost photoPost = PhotoPost();

  Future<Response> _getDetailPhotoPost(url) async {
    var res = await get(url);
    return res;
  }

  void getDetailPhotoPost() async {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['getDetailPhoto'] +
          '?idToken=${token}&photoId=${photoData.id}';
      _getDetailPhotoPost(url).then((res) {
        if (res.body != null && res.body != 'null') {
          photoPost =
              PhotoPost.fromJson(json.decode(utf8.decode(res.bodyBytes)));
          getAuthor();
          checkLike();
          load = true;
        }
      }).catchError((error) {});
    });
  }

  checkOwning() {
    getUserId().then((userId) {
      if (userId == authorData.userId) {
        setState(() {
          myPost = true;
        });
      }
    });
  }

  // Like photo

  Future<Response> _likePhotoPost(url) async {
    var res = await get(url);
    return res;
  }

  void likePhotoPost() async {
    String token;
    var userId = await getUserId();
    setState(() {
      like = !like;
      if (photoPost.favorites.contains(userId)) {
        photoPost.favorites.remove(userId);
      } else {
        photoPost.favorites.add(userId);
      }
    });
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['likePhoto'] +
          '?idToken=${token}&photoId=${photoData.id}';
      _likePhotoPost(url).then((res) {}).catchError((error) {});
    });
  }

  //-----------

  getDateString() {
    if (photoPost?.date == null) {
      return "no date";
    }
    var dateTime = DateTime.fromMillisecondsSinceEpoch(photoPost.date * 1000);
    return "${dateTime.hour.toString()}:${dateTime.minute.toString()} ${dateTime.day.toString()}/${dateTime.month.toString()}/${dateTime.year.toString()}";
  }

  checkLike() async {
    var userId = await getUserId();
    if (photoPost.favorites.contains(userId)) {
      setState(() {
        like = true;
      });
    }
  }

  // Actions

  Column _bottomSheetPubActions() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text('Delete post'),
          onTap: () {
            showDeleteAlertDialog(context);
          },
        ),
      ],
    );
  }

  void _showPubActions() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: _bottomSheetPubActions(),
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                )),
          );
        });
  }

  showDeleteAlertDialog(BuildContext context) {
    Widget ok = FlatButton(
      child: Text(
        'delete',
        style: TextStyle(color: Colors.pink[600]),
      ),
      onPressed: () {
        deletePost();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    Widget cancel = FlatButton(
      child: Text('cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Deleting a post'),
      content: Text('Are you sure you want to delete the post'),
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
  //--------------

  //delete post

  Future<Response> _deletePost(url) async {
    var res = await get(url);
    return res;
  }

  void deletePost() async {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['deletePhoto'] +
          '?idToken=${token}&photoId=${photoData.id}';
      _deletePost(url).then((res) {}).catchError((error) {});
    });
  }

  //--------------
}
