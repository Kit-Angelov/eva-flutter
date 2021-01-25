import 'package:flutter/material.dart';

class LoadWidget extends StatelessWidget {
  LoadWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(44, 62, 80, 1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Stack(children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 90,
                      height: 100,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "STRINGER",
                            style: TextStyle(color: Colors.white, fontSize: 55),
                          )),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 10,
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: new BoxDecoration(
                          color: Colors.pink[600],
                          // borderRadius: BorderRadius.circular(9999.0),
                        )),
                  ),
                ])),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ));
  }
}
