import 'package:flutter/material.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/lista/lista_view.dart';

class MenuCard extends StatelessWidget {
  final String texto;
  final IconData icone;
  final MaterialColor color;

  MenuCard({this.texto, this.icone, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          push(context, ListaView(), replace: true);
        },
        splashColor: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icone, size: 70, color: color,),
              Text(texto, style: TextStyle(fontSize: 17),)
            ],
          ),
        ),
      ),
    );
  }
}
