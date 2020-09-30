import 'package:firebase_core/firebase_core.dart';
import 'package:jklist/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jklist/splash_screen.dart';
import 'package:jklist/generated/l10n.dart';
import 'package:jklist/services/event_bus.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Register all the models and services before the app starts
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(PrincipalApp());
}

class PrincipalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EventBus>(
          create: (context) => EventBus(),
          dispose: (context, bus) => bus.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'JK List',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white
        ),
        supportedLocales: DSString.delegate.supportedLocales,
        localizationsDelegates: [
          DSString.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        home: SplashScreen(),
      ),
    );
  }
}
