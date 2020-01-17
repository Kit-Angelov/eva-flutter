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
      body: Column(
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
          TextField(
            autofocus: true,
            maxLength: 30,
            decoration: InputDecoration(
              hintText: "search",
              counterText: "",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10)
            ),
          )
        ],
      )
    );
  }
}
