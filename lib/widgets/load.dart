import 'package:flutter/material.dart';

class LoadWidget extends StatelessWidget {
  LoadWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Color.fromRGBO(44, 62, 80, 1),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
