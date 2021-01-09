import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_search/mapbox_search.dart';

typedef void GeocodingCallback(LatLng latLng);

class SearchPlaceWidget extends StatefulWidget {
  SearchPlaceWidget({
    Key key,
    this.geocodingCallback,
  }) : super(key: key);

  final GeocodingCallback geocodingCallback;
  @override
  State<StatefulWidget> createState() => _SearchPlaceWidgetState();
}

class _SearchPlaceWidgetState extends State<SearchPlaceWidget> {
  TextEditingController _textController = TextEditingController(text: "");

  List placeResult = [];

  var placesSearch = PlacesSearch(
    apiKey:
        'pk.eyJ1Ijoia2l0YW5nZWxvdiIsImEiOiJjamd1aHZncTMxMjF6MndtcWdjZGZhY2g1In0.s4vQ4pbKkTCpKt6psOPxMw',
    limit: 15,
  );

  void getPlaces() async {
    if (_textController.text == '') {
      return;
    }
    placeResult = await placesSearch.getPlaces(_textController.text);
    setState(() {});
  }

  void _fillSearchInput(MapBoxPlace place) {
    setState(() {
      _textController = TextEditingController(text: place.text);
      getPlaces();
    });
  }

  void _positionToPlace(MapBoxPlace place) {
    var latLng = LatLng(place.center[1], place.center[0]);
    widget.geocodingCallback(latLng);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.search, color: Colors.black54),
                      SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          maxLength: 150,
                          autofocus: true,
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: "Search",
                            counterText: "",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                          onChanged: (_) {
                            getPlaces();
                          },
                          onSubmitted: (String text) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Divider(
                  height: 1,
                ),
                Expanded(
                  child: placeResult.length == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "no results",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black26),
                            )
                          ],
                        )
                      : ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                                  height: 10,
                                  thickness: 1,
                                  indent: 0,
                                  endIndent: 0,
                                  color: Colors.black12),
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          itemCount: placeResult.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Row(children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      _fillSearchInput(placeResult[index]);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          placeResult[index].text != null
                                              ? placeResult[index].text
                                              : "",
                                          style: TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          placeResult[index].placeName != null
                                              ? placeResult[index].placeName
                                              : "",
                                          style:
                                              TextStyle(color: Colors.black38),
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
                                      child: Icon(Icons.location_on,
                                          color: Colors.black54),
                                      onPressed: () {
                                        _positionToPlace(placeResult[index]);
                                      },
                                    ))
                              ]),
                            );
                          }),
                )
              ],
            )));
  }
}
