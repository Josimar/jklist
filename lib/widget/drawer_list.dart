import 'package:flutter/material.dart';
import 'package:jklist/generated/l10n.dart';
import 'package:jklist/model/usuario_model.dart';
import 'package:jklist/services/firebase_service.dart';
import 'package:jklist/utilitarios.dart';
import 'package:jklist/view/lista/lista_view.dart';
import 'package:jklist/view/login/login_view.dart';
import 'package:jklist/widget/alert.dart';

// https://material.io/resources/icons/?style=baseline

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<UsuarioModel> userModel = UsuarioModel.get();

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder<UsuarioModel>(
              future: userModel,
              builder: (context, snapshot){
                UsuarioModel user = snapshot.data;
                return user != null ? _header(user) : Container();
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Listas'),
              subtitle: Text('Todos as listas'),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.pop(context);
                push(context, ListaView(), replace: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              subtitle: Text('clique para sair'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _onClickLogout(context),
            )
          ],
        ),
      ),
    );
  }

  UserAccountsDrawerHeader _header(UsuarioModel userModel) {
    return UserAccountsDrawerHeader(
      accountName: Text(userModel.nome),
      accountEmail: Text(userModel.email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: userModel.urlfoto != null ? NetworkImage(userModel.urlfoto) : AssetImage('assets/userlogin.png'),
      ),
    );
  }

  _onClickLogout(BuildContext context) {
    UsuarioModel.clear();
    FirebaseService().logout();
    Navigator.pop(context);
    push(context, LoginView(), replace: true);
  }
}
