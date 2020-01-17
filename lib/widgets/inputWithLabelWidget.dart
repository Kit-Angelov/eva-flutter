import 'package:flutter/material.dart';

class InputWithLabelWidget extends StatelessWidget {

  final TextEditingController _textController;
  final _submitFunction;
  final int _maxLength;
  final String _labelText;
  final String _hintText;

  InputWithLabelWidget(this._textController, this._submitFunction, this._maxLength, this._labelText, this._hintText);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: false,
      autofocus: false,
      maxLength: _maxLength,
      controller: _textController,
      onSubmitted: _submitFunction,
      decoration: InputDecoration(
        hintText: _hintText,
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
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0)
      ),
    );
  }
}
