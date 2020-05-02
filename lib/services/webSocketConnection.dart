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
  Map urlParams;
  int state = 0;

  WebSocketConnection(this.url, {this.urlParams, this.messageHandle, }) {
    if (messageHandle == null) {
      messageHandle = defautlMessageHandle;
    }
    print(messageHandle);
  }
  
  initws(wsURL) {
    ws = null;
    wsFuture = WebSocket
      .connect(wsURL)
      .timeout(new Duration(seconds: 5))
      .then((v) {
        ws = v;
        ws.handleError((e, s) {
          timeprint("ERROR HANDLED $e");
          ws = null;
          state = 2;
        });
        ws.done.then((v) {
          timeprint("DONE");
        });
        ws.listen((d) {
          transferredData = d;
          timeprint("DATA RECEIVED");
          messageHandle(d);
        }, onError: (e, stack) {
          timeprint("ERROR ON LISTEN");
          ws = null;
          state = 2;
        }, onDone: () {
          timeprint("DONE ON LISTEN");
          ws = null;
          state = 2;
        });
      }, onError: (e, stack) {
        timeprint("onerror $e");
        ws = null;
        state = 2;
      });
    timeprint("inited");
    state = 1;
  }

  defautlMessageHandle(data) {
    print(data);
  }

  timeprint(msg){
    print(new DateTime.now().toString() + "    " +  msg);
  }

  void setParams(urlParams) {
    this.urlParams = urlParams;
  }

  close() {
    print("CLOSE WS");
    if (ws != null) {
      ws.close();
    }
    state = 2;
  }
  
  connect() {
    String token;
    getUserIdToken().then((idToken) {
      token = idToken;
      var wsURL = '${url}?idToken=${token}';
      if (urlParams != null) {
        for (var item in urlParams.entries){
          print("${item.key} - ${item.value}");
          wsURL = '${wsURL}&${item.key}=${item.value}';
        }
      }
      initws(wsURL);
    });
  }

  void send(data) {
    if (ws != null) {
      ws.add(jsonEncode(data));
    }
  }
}
