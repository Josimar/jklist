import 'package:flutter/material.dart';
import 'package:jklist/generated/l10n.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/lista/lista_view.dart';
import 'package:jklist/widget/drawer_list.dart';
import 'package:jklist/widget/text.dart';

// ToDo: https://pt.stackoverflow.com/questions/449012/flutter-alinhamento-row
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DSString.of(context).nomeApp),
      ),
      drawer: DrawerList(),
      body: Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        push(context, ListaView(), replace: true);
                      },
                      child:
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: const EdgeInsets.all(10.0),
                          color: Color.fromRGBO(0, 113, 128, 10),
                          width: 150,
                          height: 100,
                          child: Center(
                            child: Text(
                             'Listas',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
