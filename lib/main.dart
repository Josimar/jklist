import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jklist/model/usuario_model.dart';
import 'package:jklist/services/dialog_service.dart';
import 'package:jklist/utils/dialog_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jklist/view/startup/startup_view.dart';
import 'package:jklist/services/navigator_service.dart';
import 'package:jklist/utils/locator.dart';
import 'package:jklist/utils/router.dart';
import 'package:jklist/splash_screen.dart';
import 'package:jklist/generated/l10n.dart';
import 'package:jklist/services/event_bus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:jklist/view/categoria/categoria_view_model.dart';

void main() async {
  // Register all the models and services before the app starts
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(PrincipalApp());
}

class PrincipalApp extends StatelessWidget {
  final UsuarioModel userModel;
  const PrincipalApp({Key key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /*
    final ThemeData temaIOS = ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.grey,
        accentColor: Colors.teal,
        fontFamily: 'Lato',
        brightness: Brightness.light, // isDark ? Brightness.dark : Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Anton',
        )
    );
    */
    final ThemeData temaAndroid = ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4, 125, 141),
        accentColor: Colors.teal,
        fontFamily: 'Lato',
        brightness: Brightness.light, // isDark ? Brightness.dark : Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Lato',
        )
    );

    return MultiProvider(
      providers: [
        Provider<EventBus>(
          create: (context) => EventBus(),
          dispose: (context, bus) => bus.dispose(),
        ),
        ChangeNotifierProvider<CategoriaViewModel>(create: (_) => CategoriaViewModel()),
      ],
      child: MaterialApp(
        title: 'JK List',
        debugShowCheckedModeBanner: false,
        supportedLocales: DSString.delegate.supportedLocales,
        navigatorKey: locator<NavigationService>().navigationKey,
        theme: Platform.isIOS ? temaAndroid : temaAndroid,
        onGenerateRoute: generateRoute,
        home: StartupView(), // SplashScreen(),
        builder: (context, child) => Navigator(
          key: locator<DialogService>().dialogNavigationKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DialogManager(child: child)
          ),
        ),
        localizationsDelegates: [
          DSString.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      ),
    );
  }
}
