import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/places.dart';

class SearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final kGoogleApiKey = "AIzaSyD7WB7-TbriUn9g0xHopM8h2d78quMY10E";
  final places = new GoogleMapsPlaces(apiKey: "AIzaSyD7WB7-TbriUn9g0xHopM8h2d78quMY10E");
  final List<String> entries = ["1", "4", '5'];
  // List<Prediction> entries;
  String sessionToken;

  Future<void> searchPlaceByText(String text) async{
    PlacesAutocompleteResponse response = await places.autocomplete(text, sessionToken: sessionToken);
    print(response.predictions);
    for (var r in response.predictions) {
      print(r.description);
      print(r.placeId);
      print(r.structuredFormatting.mainText);
      print(r.structuredFormatting.secondaryText);
    }
  }

  @override
  void initState() {
    super.initState();
    var uuid = Uuid();
    setState(() {
      sessionToken = uuid.v4();
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
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanDown: (_){FocusScope.of(context).requestFocus(FocusNode());},
                            onTap: (){print("tap");}, 
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "asdf",
                                  style: TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "qwerqwre",
                                  style: TextStyle(color: Colors.black38),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 30.0,
                          width: 1.0,
                          color: Colors.black12,
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
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 99,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "search",
                        counterText: "",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      onChanged: (String text){searchPlaceByText(text);},
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
