import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {

  //UserModel get currentUser => _authenticationService.currentUser;
  // bool get userLogged => _authenticationService.userLogged;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
