import 'package:flutter/material.dart';
import 'package:jklist/home_page.dart';
import 'package:jklist/model/usuario_model.dart';
import 'package:jklist/sqlite/sqlite_helper.dart';
import 'package:jklist/utilitarios.dart';
import 'package:jklist/view/login/login_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future sqliteFuture = SQLiteHelper.getInstance().db;
    Future delayFuture = Future.delayed(Duration(seconds: 3));
    Future<UsuarioModel> userFuture = UsuarioModel.get();

    Future.wait([sqliteFuture, userFuture, delayFuture]).then((List values){
      UsuarioModel user = values[1];

      if (user != null){
        push(context, HomePage(), replace: true);
      }else{
        push(context, LoginView(), replace: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/splashscreen.jpg"),
              fit: BoxFit.cover
          )
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
