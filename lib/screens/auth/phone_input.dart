import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPhoneInputScreen extends StatefulWidget {

  @override
  _AuthPhoneInputState createState() => _AuthPhoneInputState();
}

class _AuthPhoneInputState extends State<AuthPhoneInputScreen> {

  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;

  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential credential) {
      setState(() {
          print('Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded');
      });
    };

    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      setState(() {
        print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');}
        );
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + _phoneNumberController.text);
      Navigator.pushReplacementNamed(context, '/authSmsCodeInput', arguments: this.verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumberController.text,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
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
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              controller:  _phoneNumberController,
            ),
            new FlatButton(
              onPressed: () => _checkAuth(),
              child: const Text("check")
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _sendCodeToPhoneNumber(),
        tooltip: 'get code',
        child: new Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}