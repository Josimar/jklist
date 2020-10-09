import 'package:flutter/material.dart';

class ListError extends StatelessWidget {
  final String message;
  ListError(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
      ),
    );
  }
}
