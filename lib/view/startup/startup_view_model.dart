import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jklist/model/base_model.dart';
import 'package:jklist/services/firebase_service.dart';
import 'package:jklist/services/navigator_service.dart';
import 'package:jklist/utils/locator.dart';
import 'package:jklist/utils/route_names.dart';

class StartUpViewModel extends BaseModel {
  final FirebaseService _authenticationService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future handleStartUpLogic() async {
    // _authenticationService.signOut(); // ToDo: logoff na raiz

    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    var viewIntroUser = false;
    if (hasLoggedInUser){
      viewIntroUser = await _authenticationService.isUserViewIntro(currentUser.uid);
    }

    new Timer(const Duration(milliseconds: 3000), (){
      if (hasLoggedInUser) {
        if (viewIntroUser){
          _navigationService.navigateTo(IntroViewRoute);
        }else{
          _navigationService.navigateTo(HomeViewRoute);
        }
      } else {
        _navigationService.navigateTo(LoginViewRoute);
      }
    });
  }

  void goToHome(){
    _navigationService.navigateTo(HomeViewRoute);
  }
}
