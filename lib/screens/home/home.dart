
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eva/screens/map/map.dart';
import 'package:eva/screens/profile/profile.dart';

import 'package:eva/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  var _currentWidget;

  List _widgetOptions = [
    ProfileScreen(),
    MapScreen(),
    SearchWidget(),
    Text(
      'Apps',
    ),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentWidget = _widgetOptions.elementAt(_selectedIndex);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentWidget = _widgetOptions.elementAt(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _currentWidget
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
          ),
        ],
        currentIndex: _selectedIndex,
        iconSize: 30.0,
        onTap: _onItemTapped,
      ),
    );
  }
}
