import 'package:flutter/material.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/utils/route_names.dart';

import 'package:jklist/view/intro_view.dart';

import 'package:jklist/view/login/login_view.dart';
import 'package:jklist/view/signup/signup_view.dart';

import 'package:jklist/home_page.dart';

import 'package:jklist/view/produto/produto_add.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final RouteArguments args = settings.arguments;

  switch (settings.name) {
    case LoginViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: SignupView(),
      );
    case HomeViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: HomePage(),
      );
    case IntroViewRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: IntroView(),
      );
    case ProdutoAddRoute:
      return _getPageRoute(
        routeName: settings.name,
        viewToShow: ProdutoAdd(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          ));
  }
}

PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
