import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:eva/services/firebaseAuth.dart';
import 'package:eva/config.dart';
import 'package:eva/models/profile.dart';

class UserDetailWidget extends StatefulWidget {
  final String userId;
  final closeCallback;

  UserDetailWidget({Key key, this.userId, this.closeCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserDetailWidgetState();
}

class _UserDetailWidgetState extends State<UserDetailWidget> {
  var currentWidget;

  Widget miniWidget (BuildContext context, ScrollController scrollController)  {
    return ListView(
      padding: const EdgeInsets.all(0),
      physics: BouncingScrollPhysics(),
      controller: scrollController,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade500,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: userData != null 
                        ? userData.photo != '' ? Image.network(userData.photo + '/300.jpg', fit: BoxFit.cover,) : Image.network('https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg', fit: BoxFit.cover,)
                        : Image.network('https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg', fit: BoxFit.cover,)
                  ),
                ),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userData != null ? userData.username : "username",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 20,),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: (){print("close"); widget.closeCallback();},
                )
              ],
            ),
          )
        ),
      ]
    );
  }

  Widget maxiWidget (BuildContext context, ScrollController scrollController) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      controller: scrollController,
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
                      child: userData != null 
                        ? userData.photo != '' ? Image.network(userData.photo + '/300.jpg', fit: BoxFit.cover,) : Image.network('https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg', fit: BoxFit.cover,)
                        : Image.network('https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg', fit: BoxFit.cover,)
                    )
                  ],
                ),
              ),
            ]
          )
        )
      ]
    );
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    setState(() {
      currentWidget = miniWidget;
    });
  }

  @override
  void didUpdateWidget(covariant UserDetailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var minHeight = 60 / MediaQuery.of(context).size.height;
    var maxHeight = 0.7;
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent > minHeight && currentWidget != maxiWidget) {
          currentWidget = maxiWidget;
          setState(() {});
        } else if((notification.extent == minHeight && currentWidget != miniWidget)){
          currentWidget = miniWidget;
          setState(() {});
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: minHeight,
        minChildSize: minHeight,
        maxChildSize: maxHeight,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: Colors.white,
            child: currentWidget(context, scrollController)
          );
        }
      )
    );
  }

  Profile userData;

  Future<http.Response> _getUserData(url) async{
    var res = await http.get(url);
    return res;
  }

  void getUserData() async{
    String token;
    print("GET");
    getUserIdToken().then((idToken) {
      token = idToken;
      var url = config.urls['user'] + '/?idToken=${token}&userId=${widget.userId}';
      _getUserData(url).then((res) {
        if (res.body != null && res.body !='null') {
          print(res.body);
          setState(() {
            userData = Profile.fromJson(json.decode(res.body));
          });
        }
      });
    });
  }
}
