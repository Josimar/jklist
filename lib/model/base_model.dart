import 'package:flutter/material.dart';
import 'package:jklist/model/usuario_model.dart';
import 'package:jklist/services/firebase_service.dart';
import 'package:jklist/utils/locator.dart';

class BaseModel extends ChangeNotifier {

  final FirebaseService _authenticationService = locator<FirebaseService>();

  UsuarioModel get currentUser => _authenticationService.currentUser;
  bool get userLogged => _authenticationService.userLogged;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
