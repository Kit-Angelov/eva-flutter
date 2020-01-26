import 'package:eva/utils/geolocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eva/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:eva/screens/home/modalBottomSheets.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<MapWidgetState> _mapWidgetState = GlobalKey<MapWidgetState>();
  MapWidget map;
  GeolocationStatus geolocationStatus;
  Position myPosition;

  Future<void> _checkGeolocationPermissionStatus() async {
    geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
  }

  void _searchPlaceCallback(lat, lng) {
    _mapWidgetState.currentState.setCameraPosition(lat, lng);
  }
  
  void _updateMyLocationCallback(Position position) {
    setState(() {
      myPosition = position;
    });
  }

  void _moveToMyPosition() async{
    await getMyLocation(_updateMyLocationCallback);
    await _checkGeolocationPermissionStatus();
    if (geolocationStatus == GeolocationStatus.granted) {
      _mapWidgetState.currentState.setCameraPosition(myPosition.latitude, myPosition.longitude);
    }
  }

  @override
  void initState() {
    super.initState();
    _moveToMyPosition();
    setState(() {
      map = MapWidget(key: _mapWidgetState);
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
              Expanded(child: map,),
            ],),
            Positioned(
              bottom: 30,
              left: 5,
              child: Opacity(
                opacity: 0.9,
                child: FlatButton.icon(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Colors.purple.shade500,
                  textColor: Colors.white,
                  icon: Icon(Icons.search),
                  label: Text(
                    "places".toUpperCase(),
                    style: TextStyle(fontSize: 18),  
                  ),
                  onPressed: (){openPlaceSearch(context, _searchPlaceCallback);},
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 5,
              child: 
              GestureDetector(
                onTap: (){Navigator.pushNamed(context, '/profile');},
                child: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade500,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/9/9a/Gull_portrait_ca_usa.jpg",
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 5,
              child: Opacity(
                opacity: 0.9,
                child: FloatingActionButton(
                  backgroundColor: Colors.purple.shade500,
                  child: Icon(Icons.my_location),
                  elevation: 0.0,
                  mini: true,
                  heroTag: null,
                  onPressed: (){_moveToMyPosition();},
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: 5,
              child: Opacity(
                opacity: 0.9,
                child: FloatingActionButton(
                  backgroundColor: Colors.purple.shade500,
                  child: Icon(Icons.apps),
                  elevation: 0.0,
                  mini: true,
                  heroTag: null,
                  onPressed: (){_moveToMyPosition();},
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
