
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eva/widgets/inputWithLabelWidget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _usernameTextController;

  void usernameSubmit(String value) {
    print(value);
  }

  @override
  void initState() {
    super.initState();
    _usernameTextController = TextEditingController(text: 'initial text');
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
                  InputWithLabelWidget(_usernameTextController, usernameSubmit, 15, "username"),
                  Divider(height: 30, thickness: 1, indent: 10, endIndent: 10),
                  Row(children: <Widget>[
                    Expanded(
                      child: InputWithLabelWidget(_usernameTextController, usernameSubmit, 15, "phone"),
                    )
                  ],)
                ],
              ),
            )
          ],
        )
      )
    );
  }
}