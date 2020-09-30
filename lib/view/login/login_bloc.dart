import 'package:jklist/api/response_api.dart';
import 'package:jklist/bloc/simple_bloc.dart';
import 'package:jklist/model/usuario_model.dart';
import 'package:jklist/services/firebase_service.dart';
import 'package:jklist/view/login/login_api.dart';

class LoginBloc extends SimpleBloc<bool>{
  Future<ResponseApi> login(String login, String senha) async {

    addStream(true);

    // ResponseApi response = await LoginApi.login(login, senha);
    ResponseApi response = await FirebaseService().loginFirebase(login, senha);

    addStream(false);

    return response;

  }
}