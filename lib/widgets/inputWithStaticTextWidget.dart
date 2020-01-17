import 'package:flutter/material.dart';

class InputWithStaticTextWidget extends StatelessWidget {
  final String _staticText;
  final TextEditingController _textController;
  final _submitFunction;
  final int _maxLength;
  final String _hintText;

  InputWithStaticTextWidget(this._textController, this._submitFunction, this._maxLength, this._staticText, this._hintText);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            _staticText
          ),
          Expanded(
            child: TextField(
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
                errorStyle: TextStyle(
                  color: Colors.black
                ),
                contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0)
              ),
            ),
          )
        ],
      ),
    );
  }
}
