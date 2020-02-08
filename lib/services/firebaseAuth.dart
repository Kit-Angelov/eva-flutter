import 'package:firebase_auth/firebase_auth.dart';


Future<bool> checkAuth() async {
  FirebaseAuth _auth = await FirebaseAuth.instance;
  return await _auth.currentUser().then((user) {
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }).catchError((error) {
    return false;
  });
}

Future<String> getUserIdToken() async {
  FirebaseAuth _auth = await FirebaseAuth.instance;
  return await _auth.currentUser().then((user) {
    if (user != null) {
      user.getIdToken().then((idTokenResult) {
        return idTokenResult.token;
      }).catchError((error) {
        return "";
      });
    } else {
      return "";
    }
  }).catchError((error) {
    return "";
  });
}