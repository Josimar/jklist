import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/generated/l10n.dart';
import 'package:jklist/home_page.dart';
import 'package:jklist/services/firebase_service.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/login/login_bloc.dart';
import 'package:jklist/view/login/login_view_model.dart';
import 'package:jklist/widget/alert.dart';
import 'package:jklist/widget/button_custom.dart';
import 'package:jklist/widget/carregando.dart';
import 'package:jklist/widget/text.dart';
import 'package:jklist/widget/textForm.dart';
import 'package:stacked/stacked.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginBloc = LoginBloc();
  GoogleSignInAccount _currentUser;

  TextEditingController _txtLogin = TextEditingController();
  TextEditingController _txtSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _validatorLogin(String texto){
    if (texto.isEmpty){
      return 'Digite um login';
    }
    return null;
  }
  String _validatorSenha(String texto){
    if (texto.isEmpty){
      return 'Digite uma senha';
    }
    if (texto.length < 3){
      return "A senha precisa ter pelo menos 3 caracteres";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,

        body: model.busy ?
          Carregando()
        :
        Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 50, bottom: 100),
                  child: Center(
                    child: text('Acesso ao sistema', fontSize: 24, color: Theme.of(context).primaryColor),
                  ),
                ),
                TextFormCustom('Login', 'Digite o login', controller: _txtLogin, validator: _validatorLogin, keyboardType: TextInputType.emailAddress),
                SizedBox(height: 10),
                TextFormCustom('Senha', 'Digite a senha', password: true, controller: _txtSenha, validator: _validatorSenha),
                SizedBox(height: 20),
                Container(
                  height: 46,
                  margin: EdgeInsets.only(top: 20),
                  child: ButtonCustom(
                      'Login',
                      onPressed: () => model.login(login: TipoLogin.FIREBASE, email: _txtLogin.text.trim(), password: _txtSenha.text.trim()),
                      showProgress: model.busy
                  ),
                ),
                /* se precisar mudar apenas o botão ou uma área
                StreamBuilder<bool>(
                    stream: _loginBloc.stream,
                    builder: (context, snapshot) {
                      return ButtonCustom(
                          'Login',
                          onPressed: () => model.login(login: TipoLogin.FIREBASE, email: _txtLogin.text.trim(), password: _txtSenha.text.trim()),
                          showProgress: model.busy
                      );
                    }
                ),
                */
                Container(
                  height: 46,
                  margin: EdgeInsets.only(top: 20),
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: () => model.login(login: TipoLogin.GOOGLE, email: _txtLogin.text.trim(), password: _txtSenha.text.trim()),
                  ),
                )
              ],
            ),
          ),
        )
      )
    );
  }

}