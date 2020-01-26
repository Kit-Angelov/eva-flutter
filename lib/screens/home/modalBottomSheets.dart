import 'package:flutter/material.dart';
import 'package:eva/widgets/widgets.dart';


void openPlaceSearch(context, searchPlaceCallback) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Container(
                height: 20,
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
                      onTap: (){Navigator.pop(context);},
                      child: Text(
                        "close",
                        style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w400,),
                      ),
                    )
                  ],
                ),
              ), 
            ),
            Divider(height: 0, thickness: 1, indent: 0, endIndent: 0),
            Expanded(
              child: SearchPlaceWidget(geocodingCallback: searchPlaceCallback),
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


 void openAppsList(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
      return Container(
        child: _bottomSheetAppsList(),
        height: 120,
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
  
  Column _bottomSheetAppsList() {
    return Column (
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('make photo'),
          // onTap: (){_getImageFromDevice(ImageSource.camera);},
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('choose from gallery'),
          // onTap: (){_getImageFromDevice(ImageSource.gallery);},
        )
      ],
    ); 
  }