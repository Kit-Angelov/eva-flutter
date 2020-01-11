import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/map/map.dart';
import 'package:eva/models/testmodel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = {
      '/': (context) => LoadPage(),
      '/home': (context) => HomeScreen(title: 'Lool'),
      '/map': (context) => MapScreen(),
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
  var text = "Heeey";

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () {
        setState(() {
          Navigator.pushReplacementNamed(context, '/home');
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
