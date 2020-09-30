import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/generated/l10n.dart';
import 'package:jklist/home_page.dart';
import 'package:jklist/services/firebase_service.dart';
import 'package:jklist/utilitarios.dart';
import 'package:jklist/view/login/login_bloc.dart';
import 'package:jklist/widget/alert.dart';
import 'package:jklist/widget/button_custom.dart';
import 'package:jklist/widget/textForm.dart';

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text(DSString.of(context).utilitarios)
        ),
        body: _body(context)
    );
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            TextFormCustom('Login', 'Digite o login', controller: _txtLogin, validator: _validatorLogin, keyboardType: TextInputType.emailAddress),
            SizedBox(height: 10),
            TextFormCustom('Senha', 'Digite a senha', password: true, controller: _txtSenha, validator: _validatorSenha),
            SizedBox(height: 20),
            StreamBuilder<bool>(
                stream: _loginBloc.stream,
                builder: (context, snapshot) {
                  return ButtonCustom(
                      'Login',
                      onPressed: () => _onClickLogin(context),
                      showProgress: snapshot.data ?? false
                  );
                }
            ),
            Container(
              height: 46,
              margin: EdgeInsets.only(top: 20),
              child: SignInButton(
                Buttons.Google,
                onPressed: _onClickGoogle,
              ),
            )
          ],
        ),
      ),
    );
  }

  _onClickLogin(BuildContext context) async {
    if (!_formKey.currentState.validate()){
      return;
    }

    String login = _txtLogin.text.trim();
    String senha = _txtSenha.text.trim();

    ResponseApi response = await _loginBloc.login(login, senha);

    if (response.ok){
      // UsuarioModel usuarioModel = response.result;
      push(context, HomePage(), replace: true);
    }else{
      alert(context, 'Erro ao logar', response.msg);
    }
  }

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

  _onClickGoogle() async {
    final service = FirebaseService();
    ResponseApi response = await service.loginGoogle();

    if (response.ok){
      push(context, HomePage(), replace: true);
    }else{
      alert(context, "Erro ao logar", response.msg);
    }
  }
}
