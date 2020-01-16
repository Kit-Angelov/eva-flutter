

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: 'initial text');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Image(
                      image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Opacity(
                      opacity: 0.8,
                      child: FloatingActionButton(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.photo_camera),
                        elevation: 0.0,
                        mini: true,
                        onPressed: (){print("new photo");},
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Column(
                children: <Widget>[
                  TextField(
                    obscureText: false,
                    autofocus: false,
                    maxLength: 15,
                    controller: _textController,
                    onSubmitted: (String value){print(value);},
                    decoration: InputDecoration(
                      counterText: "",
                      border: UnderlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      labelText: 'username',
                      labelStyle: TextStyle(
                        color: Colors.grey
                      ),
                      errorStyle: TextStyle(
                        color: Colors.black
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0)
                    ),
                  )
                ],
              ),
            )
          ],
        )
      )
    );
  }
}