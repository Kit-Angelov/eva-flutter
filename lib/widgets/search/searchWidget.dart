import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

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
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Text("asdf"),
                  Text("qwerqwre")
                ],
              ),
            ),
            Divider(height: 0, thickness: 1, indent: 40, endIndent: 15, color: Colors.grey.shade300,),
            Row(
              children: <Widget>[
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    maxLength: 30,
                    decoration: InputDecoration(
                      hintText: "search",
                      counterText: "",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      // contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10)
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.shade300,
                  // margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                ButtonTheme(
                  height: 30,
                  minWidth: 30,
                  child: FlatButton(
                    child: Icon(
                      Icons.near_me,
                      color: Colors.black54
                    ),
                    onPressed: (){print("search");},
                  )
                )
              ],
            )
          ],
        )
      )
    );
  }
}
