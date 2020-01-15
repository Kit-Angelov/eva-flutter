
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eva/screens/map/map.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MapScreen(),
      bottomNavigationBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Account'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            title: Text('Apps'),
          ),
        ],
        currentIndex: _selectedIndex,
        iconSize: 30.0,
        // selectedItemColor: Colors.amber[800],
        // showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
