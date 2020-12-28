import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthPhoneInputScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthPhoneInputState();
}

class _AuthPhoneInputState extends State<AuthPhoneInputScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;
  String verificationFiledText = '';

  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) {
      setState(() {
        print(
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        if (authException.code == 'invalidCredential') {
          verificationFiledText = 'invalid phone format';
        } else {
          print(authException.code);
          verificationFiledText = 'error sending code';
        }
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + _phoneNumberController.text);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AuthSmsCodeInputScreen(this.verificationId)));
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: "+" + _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(44, 62, 80, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Sign in",
                style: TextStyle(fontSize: 66, color: Colors.white),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Enter your phone number",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _phoneNumberController,
                maxLength: 20,
                style: TextStyle(fontSize: 19, color: Colors.white),
                decoration: InputDecoration(
                    prefixText: "+",
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 19),
                    hintText: "",
                    counterText: "",
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: new BorderSide(color: Colors.white)),
                    enabledBorder: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: new BorderSide(color: Colors.white)),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: new BorderSide(color: Colors.white)),
                    labelText: "",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 20)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(verificationFiledText),
                  ]),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: Color.fromRGBO(44, 62, 80, 1),
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    onPressed: () {
                      _sendCodeToPhoneNumber();
                    },
                    child: Text(
                      "Get sms code",
                      style: TextStyle(
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AuthSmsCodeInputScreen extends StatefulWidget {
  final String verificationId;

  AuthSmsCodeInputScreen(this.verificationId);

  @override
  _AuthSmsCodeInputState createState() => _AuthSmsCodeInputState();
}

class _AuthSmsCodeInputState extends State<AuthSmsCodeInputScreen> {
  TextEditingController _smsCodeController = TextEditingController();

  void _signInWithPhoneNumber(String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      FirebaseUser user;
      user = (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      setState(() {
        if (user != null) {
          print(user.uid);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          verificationFiledText = "sign in failed";
          print('Sign in failed');
        }
      });
    } catch (e) {
      print(e.code);
      setState(() {
        if (e.code == 'ERROR_INVALID_VERIFICATION_CODE') {
          verificationFiledText = "invalide code";
        } else if (e.code == 'ERROR_SESSION_EXPIRED') {
          verificationFiledText = "code expired";
        } else {
          verificationFiledText = "sign in failed";
        }
      });
    }
  }

  String verificationFiledText = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(44, 62, 80, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Sign in",
                style: TextStyle(fontSize: 66, color: Colors.white),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Enter sms code",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: _smsCodeController,
                maxLength: 20,
                style: TextStyle(fontSize: 19, color: Colors.white),
                decoration: InputDecoration(
                    hintText: "",
                    counterText: "",
                    border: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: new BorderSide(color: Colors.white)),
                    enabledBorder: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: new BorderSide(color: Colors.white)),
                    focusedBorder: new OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: new BorderSide(color: Colors.white)),
                    labelText: "",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 20)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(verificationFiledText),
                  ]),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: Color.fromRGBO(44, 62, 80, 1),
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    onPressed: () {
                      _signInWithPhoneNumber(_smsCodeController.text);
                    },
                    child: Text(
                      "Confirm",
                      style: TextStyle(fontSize: 19.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: Color.fromRGBO(44, 62, 80, 1),
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 19.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
