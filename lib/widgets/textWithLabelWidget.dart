import 'package:flutter/material.dart';

class TextWithLabelWidget extends StatelessWidget {
  final TextEditingController _textController;
  final String _labelText;

  TextWithLabelWidget(this._textController, this._labelText);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: false,
      autofocus: false,
      controller: _textController,
      readOnly: true,
      decoration: InputDecoration(
        counterText: "",
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        labelText: _labelText,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16
        ),
        errorStyle: TextStyle(
          color: Colors.black
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0)
      ),
    );
  }
}
