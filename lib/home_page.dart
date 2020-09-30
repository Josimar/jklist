import 'package:flutter/material.dart';
import 'package:jklist/generated/l10n.dart';
import 'package:jklist/widget/drawer_list.dart';
import 'package:jklist/widget/text.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DSString.of(context).utilitarios),
      ),
      drawer: DrawerList(),
      body: Center(
        child: text(DSString.of(context).pensarHome),
      ),
    );
  }
}
