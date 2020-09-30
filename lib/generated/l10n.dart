// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class DSString {
  DSString();
  
  static DSString current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<DSString> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      DSString.current = DSString();
      
      return DSString.current;
    });
  } 

  static DSString of(BuildContext context) {
    return Localizations.of<DSString>(context, DSString);
  }

  /// `Utilities`
  String get nomeApp {
    return Intl.message(
      'Utilities',
      name: 'nomeApp',
      desc: '',
      args: [],
    );
  }

  /// `List empty`
  String get listaVazia {
    return Intl.message(
      'List empty',
      name: 'listaVazia',
      desc: '',
      args: [],
    );
  }

  /// `Click the option above to create a new one`
  String get nenhumaLista {
    return Intl.message(
      'Click the option above to create a new one',
      name: 'nenhumaLista',
      desc: '',
      args: [],
    );
  }

  /// `Think of a new home`
  String get pensarHome {
    return Intl.message(
      'Think of a new home',
      name: 'pensarHome',
      desc: '',
      args: [],
    );
  }

  /// `Utilities`
  String get utilitarios {
    return Intl.message(
      'Utilities',
      name: 'utilitarios',
      desc: '',
      args: [],
    );
  }

  /// `Transport`
  String get transporte {
    return Intl.message(
      'Transport',
      name: 'transporte',
      desc: '',
      args: [],
    );
  }

  /// `List of transport`
  String get listaTransporte {
    return Intl.message(
      'List of transport',
      name: 'listaTransporte',
      desc: '',
      args: [],
    );
  }

  /// `Error loading`
  String get errorLoad {
    return Intl.message(
      'Error loading',
      name: 'errorLoad',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<DSString> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<DSString> load(Locale locale) => DSString.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}