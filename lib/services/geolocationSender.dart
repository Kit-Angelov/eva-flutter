
import 'package:web_socket_channel/io.dart';
import 'package:geolocator/geolocator.dart';
import 'package:eva/services/firebaseAuth.dart';


class GeolocationSender {
  IOWebSocketChannel channel;
  String url;

  GeolocationSender(this.url) {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
    }).catchError((error) {
      return;
    });
    try {
      var wsUrl = '${url}?idToken=${token}';
      channel = IOWebSocketChannel.connect(wsUrl);
    } catch(e) {
      print(e);
    }
  }

  void send(Position position) {
    channel.sink.add(position);
  }
}
