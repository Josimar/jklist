import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget{
  final String text;
  final Function onPressed;
  final bool showProgress;

  ButtonCustom(this.text, {this.onPressed, this.showProgress = false});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Theme.of(context).primaryColor,
        child: showProgress ?
        Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
        ) :
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        onPressed: onPressed
    );
  }



}