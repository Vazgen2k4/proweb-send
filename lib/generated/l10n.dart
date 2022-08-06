// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to`
  String get hello_title {
    return Intl.message(
      'Welcome to',
      name: 'hello_title',
      desc: '',
      args: [],
    );
  }

  /// `Create Acount`
  String get create_title {
    return Intl.message(
      'Create Acount',
      name: 'create_title',
      desc: '',
      args: [],
    );
  }

  /// `Auth`
  String get auth_title {
    return Intl.message(
      'Auth',
      name: 'auth_title',
      desc: '',
      args: [],
    );
  }

  /// `Telephone number`
  String get number_telephone {
    return Intl.message(
      'Telephone number',
      name: 'number_telephone',
      desc: '',
      args: [],
    );
  }

  /// `Choose a country`
  String get choose_country_title {
    return Intl.message(
      'Choose a country',
      name: 'choose_country_title',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit_button {
    return Intl.message(
      'Exit',
      name: 'exit_button',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create_button {
    return Intl.message(
      'Create',
      name: 'create_button',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get auth_button {
    return Intl.message(
      'Log In',
      name: 'auth_button',
      desc: '',
      args: [],
    );
  }

  /// `I've account`
  String get have_account_link {
    return Intl.message(
      'I\'ve account',
      name: 'have_account_link',
      desc: '',
      args: [],
    );
  }

  /// `Other auth`
  String get other_auth_link {
    return Intl.message(
      'Other auth',
      name: 'other_auth_link',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start_btn_txt {
    return Intl.message(
      'Start',
      name: 'start_btn_txt',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
