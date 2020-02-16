
import 'package:web_socket_channel/io.dart';
import 'package:geolocator/geolocator.dart';
import 'package:eva/services/firebaseAuth.dart';


class GeolocationSender {
  IOWebSocketChannel channel;
  String url;

  GeolocationSender(this.url);
  
  void connect() {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      print(idToken);
      try {
        var wsUrl = '${url}?idToken=${token}';
        channel = IOWebSocketChannel.connect(wsUrl);
      } catch(e) {
        print(e);
      }
    }).catchError((error) {
      // return;
      print('asdf');
    });
  }

  void send(Position position) {
    channel.sink.add(position);
  }
}
