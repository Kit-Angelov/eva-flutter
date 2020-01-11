import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eva/models/testmodel.dart';
 
// Такое же виджет, как и SplashScreen, только передаём ему ещё и заголовок
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;
 
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
 
// Формирование состояния виджета
class _HomeScreenState extends State<HomeScreen> {
 
  // В отличии от SplashScreen добавляем AppBar
  @override
  Widget build(BuildContext context) {
    final testModel = Provider.of<TestModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(testModel.getUsername()),
            FloatingActionButton(
              onPressed: () => testModel.setUsername('asdf'),
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}