import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/places.dart';
import "package:google_maps_webservice/geocoding.dart";

typedef void GeocodingCallback(double lat, double lng);

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
  final places = new GoogleMapsPlaces(apiKey: "AIzaSyD7WB7-TbriUn9g0xHopM8h2d78quMY10E");
  final geocoding = new GoogleMapsGeocoding(apiKey: "AIzaSyD7WB7-TbriUn9g0xHopM8h2d78quMY10E");
  List<Prediction> placesList = [];
  String sessionToken;
  TextEditingController _textController = TextEditingController(text: "");

  Future<void> _searchPlaceByText(String text) async{
    PlacesAutocompleteResponse response = await places.autocomplete(text, sessionToken: sessionToken);
    setState(() {
      placesList = response.predictions;
    });
  }

  Future<void> _geocodingByAddress(String text) async{
    if (text == "") {
      return;
    }
    GeocodingResponse response = await geocoding.searchByAddress(text);
    if (response.status == 'OK') {
      GeocodingResult result = response.results.first;
      widget.geocodingCallback(result.geometry.location.lat, result.geometry.location.lng);
      Navigator.pop(context);
    }
  }

  void _fillSearchInput(Prediction place) {
    setState(() {
      _textController = TextEditingController(text: place.description);
    });
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
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: placesList.length < 1
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "no results",
                    style: TextStyle(fontSize: 18, color: Colors.black26),
                  )
                ],
              )
              : ListView.separated(
                physics: BouncingScrollPhysics(),
                separatorBuilder: (
                  BuildContext context, 
                  int index) => const Divider(height: 10, thickness: 1, indent: 0, endIndent: 0, color: Colors.black12),
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                itemCount: placesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){_fillSearchInput(placesList[index]);}, 
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  placesList[index].structuredFormatting.mainText != null ? placesList[index].structuredFormatting.mainText : "",
                                  style: TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  placesList[index].structuredFormatting.secondaryText != null ? placesList[index].structuredFormatting.secondaryText : "",
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
                              Icons.location_on,
                              color: Colors.black54
                            ),
                            onPressed: (){_geocodingByAddress(placesList[index].description);},
                          )
                        )
                      ],
                    )
                  );
                }
              ),
            ),
            Divider(height: 0, thickness: 1, indent: 0, endIndent: 0, color: Colors.black12,),
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
                      maxLength: 150,
                      autofocus: true,
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "search",
                        counterText: "",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      onChanged: (String text){_searchPlaceByText(text);},
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
                        Icons.location_searching,
                        color: Colors.black54
                      ),
                      onPressed: (){_geocodingByAddress(_textController.text);},
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
