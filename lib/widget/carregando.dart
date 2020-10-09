import 'package:flutter/material.dart';
import 'package:jklist/utils/utilitarios.dart';

class Carregando extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(DSStringLocal.carregando),
          SizedBox(height: 33),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
