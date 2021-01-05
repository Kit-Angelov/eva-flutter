import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

//app imports
import 'utils/routingTransitions.dart';
import 'services/firebaseAuth.dart';

//models
import 'models/myCurrentLocation.dart';
import 'models/photoData.dart';

//screens
import 'screens/auth/phoneAuth.dart';
import 'screens/profile/profile.dart';
import 'screens/home/home.dart';
import 'screens/pubPhoto/pubPhoto.dart';
import 'screens/pubPhotoDetail/pubPhotoDetail.dart';
import 'package:eva/screens/profile/enterUsername.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final routes = {
      '/': (context) => LoadPage(),
      '/authPhoneInput': (context) => AuthPhoneInputScreen(),
      '/home': (context) => HomeScreen(),
      '/detailPubPhoto': (context) => PubPhotoDetailScreen(),
      '/profile': (context) => ProfileScreen(),
      '/pubPhoto': (context) => PubPhotoScreen(),
    };
    List<SingleChildCloneableWidget> providers = [
      ChangeNotifierProvider(builder: (context) => MyCurrentLocationModel()),
      ChangeNotifierProvider(builder: (context) => PhotoDataModel()),
    ];
    return MultiProvider(
        providers: providers,
        child: MaterialApp(
          initialRoute: '/',
          onGenerateRoute: (settings) {
            return SlideBottomRoute(page: routes[settings.name](context));
          },
        ));
  }
}

class LoadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  var text = "Load";

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      setState(() {
        checkAuth().then((state) {
          if (state) {
            print('Auth');
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            print('No Auth');
            Navigator.pushReplacementNamed(context, '/authPhoneInput');
          }
        }).catchError((error) {
          print(error);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(this.text),
          ],
        ),
      ),
    );
  }
}
