import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogoBlankWidget extends StatelessWidget {
  final width;
  final height;
  LogoBlankWidget(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        child: FittedBox(
            child: Icon(
          FontAwesomeIcons.userAstronaut,
          color: Colors.white,
        )));
  }
}
