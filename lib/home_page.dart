import 'package:flutter/material.dart';
import 'package:jklist/generated/l10n.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/lista/lista_view.dart';
import 'package:jklist/widget/drawer_list.dart';
import 'package:jklist/widget/menu_card.dart';
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
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.black26
        ),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            MenuCard(texto: 'Home', icone: Icons.list)
          ],
        ),
      ),

    );
  }
}
