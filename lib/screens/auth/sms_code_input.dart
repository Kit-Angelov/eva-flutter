import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthSmsCodeInputScreen extends StatefulWidget {

  @override
  _AuthPhoneInputState createState() => _AuthPhoneInputState();
}

class _AuthPhoneInputState extends State<AuthSmsCodeInputScreen> {

  TextEditingController _smsCodeController = TextEditingController();
  String verificationId;
  
  void _signInWithPhoneNumber(String smsCode) async {
    print(smsCode);
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    FirebaseAuth _auth = FirebaseAuth.instance;

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    // await _auth.signInWithCredential(credential).then((user) {
    //   print(user.user.uid);
    // });
    // try {
    //   await _auth.signInWithCredential(credential).then((user) {
    //     print(user.user.uid);
    //   }).catchError((error) {
    //     print(error);
    //     print('asdf');
    //   });
    // } catch(error) {
    //   print(error);
    // }
  }

  void _checkAuth() async {
    FirebaseAuth _auth = await FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser().then((user) {
      print(user.uid);
    }).catchError((error) {
      print('no authorized');
    });
  }

  @override
  Widget build(BuildContext context) {
    this.verificationId = ModalRoute.of(context).settings.arguments;
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              controller: _smsCodeController,
            ),
            new FlatButton(
              onPressed: () => _signInWithPhoneNumber(_smsCodeController.text),
              child: const Text("Sign In")),
            new FlatButton(
              onPressed: () => _checkAuth(),
              child: const Text("check")
            )
          ],
        ),
      ),
    );
  }
}