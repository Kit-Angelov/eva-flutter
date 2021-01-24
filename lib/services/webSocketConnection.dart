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

  WebSocketConnection(
    this.url, {
    this.urlParams,
    this.messageHandle,
  }) {
    if (messageHandle == null) {
      messageHandle = defautlMessageHandle;
    }
  }

  initws(wsURL) {
    ws = null;
    wsFuture =
        WebSocket.connect(wsURL).timeout(new Duration(seconds: 5)).then((v) {
      ws = v;
      ws.handleError((e, s) {
        ws = null;
        state = 2;
      });
      ws.done.then((v) {});
      ws.listen((d) {
        transferredData = d;
        messageHandle(d);
      }, onError: (e, stack) {
        ws = null;
        state = 2;
      }, onDone: () {
        ws = null;
        state = 2;
      });
    }, onError: (e, stack) {
      ws = null;
      state = 2;
    });
    state = 1;
  }

  defautlMessageHandle(data) {}

  void setParams(urlParams) {
    this.urlParams = urlParams;
  }

  close() {
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
        for (var item in urlParams.entries) {
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
