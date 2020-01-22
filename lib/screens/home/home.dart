
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

  List _widgetOptions = [
    ProfileScreen(),
    MapScreen(),
    SearchWidget(),
    Text(
      'Apps',
    ),
  ];

  void _searchCallback(lat, lng) {
    print(lat);
    print(lng);
  }

  void _openSearch() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      isScrollControlled: true,
      context: context, 
      builder: (context) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Container(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          "search places",
                          style: TextStyle(color: Colors.black54, fontSize: 18,),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){print("close");},
                      child: Text(
                        "close",
                        style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w400,),
                      ),
                    )
                  ],
                ),
              ), 
            ),
            Expanded(
              child: SearchWidget(geocodingCallback: _searchCallback),
            )
          ],
        ),
        height: MediaQuery.of(context).size.height - 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
          )
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              Expanded(child: MapScreen(),),
            ],),
            Positioned(
              bottom: 20,
              left: 20,
              child: Opacity(
                opacity: 0.8,
                child: FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.search),
                  elevation: 0.0,
                  mini: true,
                  onPressed: (){_openSearch();},
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
