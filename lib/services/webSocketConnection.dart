import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:eva/services/firebaseAuth.dart';


class WebSocketConnection {
  Future<WebSocket> wsFuture;
  WebSocket ws;
  Exception ex;
  String transferredData;
  String url;
  var messageHandle;

  WebSocketConnection(this.url, {this.messageHandle, }) {
    if (messageHandle == null) {
      messageHandle = defautlMessageHandle;
    }
    print(messageHandle);
  }
  
  initws(wsURL) {
    transferredData = null;
    ws = null;
    wsFuture = WebSocket
        .connect(wsURL)
        .timeout(new Duration(seconds: 15))
        .then((v) {
          ws = v;
          // ws.pingInterval = new Duration(seconds: 240);
          ws.handleError((e, s) {
            timeprint("ERROR HANDLED $e");
        });
        ws.done.then((v) {
          timeprint("DONE");
          ws = null;
        });
        ws.listen((d) {
          transferredData = d;
          timeprint("DATA RECEIVED");
          messageHandle(d);
        }, onError: (e, stack) {
          timeprint("ERROR ON LISTEN");
          ws = null;
          reconnect();
        }, onDone: () {
          timeprint("DONE ON LISTEN");
          ws = null;
          reconnect();
        });
      }, onError: (e, stack) {
      timeprint("onerror $e");
      ws = null;
      reconnect();
    });
    timeprint("inited");
  }

  defautlMessageHandle(data) {
    print(data);
  }

  timeprint(msg){
    print(new DateTime.now().toString() + "    " +  msg);
  }

  void reconnect() {
    Timer(
      Duration(seconds: 5),
      () {
        if (ws == null) {
          print("reconnect");
          connect();
        }
      });
  }
  
  void connect() {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      print(idToken);
      var wsURL = '${url}?idToken=${token}';
      initws(wsURL);
    });
  }

  void send(position) {
    if (ws != null) {
      ws.add(jsonEncode(position.toJson()));
    }
  }
}
