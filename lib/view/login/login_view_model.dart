import 'package:flutter/material.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/model/base_model.dart';
import 'package:jklist/services/dialog_service.dart';
import 'package:jklist/services/firebase_service.dart';
import 'package:jklist/services/navigator_service.dart';
import 'package:jklist/utils/locator.dart';
import 'package:jklist/utils/route_names.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/login/login_api.dart';

class LoginViewModel extends BaseModel {
  final FirebaseService _authenticationService = locator<FirebaseService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future login({
    @required TipoLogin login,
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    ResponseApi response;

    if (TipoLogin.FIREBASE == login) {
      response = await _authenticationService.loginFirebase(email, password);
    }else if (TipoLogin.API == login) {
      response = await LoginApi.login(email, password);
    }else if (TipoLogin.GOOGLE == login) {
      response = await _authenticationService.loginGoogle();
    }

    setBusy(false);

    if (response.ok is bool) {
      if (response.ok) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: "Login Failure",
          description: response.msg,
        );
      }
    } else {
      await _dialogService.showDialog(
        title: "Login Failure",
        description: response.msg,
      );
    }

    /*
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
    * */

  }


}