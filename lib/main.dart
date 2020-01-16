import 'dart:core';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/phone_input.dart';
import 'screens/auth/sms_code_input.dart';
import 'package:eva/screens/home/home.dart';
import 'package:eva/models/testmodel.dart';
import 'package:flutter/services.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);
    final router = {
      '/': (context) => LoadPage(),
      '/authPhoneInput': (context) => AuthPhoneInputScreen(),
      '/authSmsCodeInput': (context) => AuthSmsCodeInputScreen(),
      '/home': (context) => HomeScreen(),
    };
    List<SingleChildCloneableWidget> providers = [
      ChangeNotifierProvider(builder: (context) => TestModel()),
    ];
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        initialRoute: '/',
        routes: router,
    ));
  }
}


class LoadPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  var text = "Load";

  Future<bool> _checkAuth() async {
    FirebaseAuth _auth = await FirebaseAuth.instance;
    return await _auth.currentUser().then((user) {
      if (user != null) {
        return true;
      } else {
        return false;
      }
    }).catchError((error) {
      return false;
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () {
        setState(() {
          _checkAuth().then((state){
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
