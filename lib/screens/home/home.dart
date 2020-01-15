
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
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
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
