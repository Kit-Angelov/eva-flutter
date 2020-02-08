import 'dart:core';
import 'dart:async';
import 'package:eva/screens/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'screens/auth/phone_input.dart';
import 'screens/auth/sms_code_input.dart';
import 'package:eva/screens/home/home.dart';
import 'package:eva/models/testmodel.dart';
import 'package:flutter/services.dart';
import 'package:eva/utils/routingTransitions.dart';
import 'package:eva/services/firebaseAuth.dart';


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
      '/authSmsCodeInput': (context) => AuthSmsCodeInputScreen(),
      '/home': (context) => HomeScreen(),
      '/profile': (context) => ProfileScreen(),
    };
    List<SingleChildCloneableWidget> providers = [
      ChangeNotifierProvider(builder: (context) => TestModel()),
    ];
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return SlideRightRoute(page: routes[settings.name](context));
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
    Timer(
      Duration(seconds: 5),
      () {
        setState(() {
          checkAuth().then((state){
            print(state);
            if (state) {
              print('Auth');
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              print('No Auth');
              Navigator.pushReplacementNamed(context, '/home');
            }
          }).catchError((error) {
            print(error);
          });
        });
      }
    );
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
