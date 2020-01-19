import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final List<String> entries = <String>['A', 'B', 'C', 'A', 'B', 'C', 'A', 'B', 'C', 'A', 'B', 'C'];

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
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                separatorBuilder: (
                  BuildContext context, 
                  int index) => const Divider(height: 10, thickness: 1, indent: 0, endIndent: 0, color: Colors.black12),
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "asdf",
                                style: TextStyle(fontSize: 16)
                              ),
                              Text(
                                "qwerqwre",
                                style: TextStyle(color: Colors.black38)
                              )
                            ],
                          ),
                        ),
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
                  );
                }
              ),
            ),
            Divider(height: 0, thickness: 1, indent: 0, endIndent: 0, color: Colors.black26,),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Row(
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
              ),
            )
          ],
        )
      )
    );
  }
}
