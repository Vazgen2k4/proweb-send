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

  /// `en`
  String get locale {
    return Intl.message(
      'en',
      name: 'locale',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get locale_lang {
    return Intl.message(
      'English',
      name: 'locale_lang',
      desc: '',
      args: [],
    );
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

  /// `Enter code from SMS`
  String get auth_code_sms_title {
    return Intl.message(
      'Enter code from SMS',
      name: 'auth_code_sms_title',
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

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Nik name`
  String get nik_name {
    return Intl.message(
      'Nik name',
      name: 'nik_name',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message(
      'Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Add account`
  String get add_account {
    return Intl.message(
      'Add account',
      name: 'add_account',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Background`
  String get bg {
    return Intl.message(
      'Background',
      name: 'bg',
      desc: '',
      args: [],
    );
  }

  /// `Night theme`
  String get night_theme {
    return Intl.message(
      'Night theme',
      name: 'night_theme',
      desc: '',
      args: [],
    );
  }

  /// `Font size`
  String get font_size {
    return Intl.message(
      'Font size',
      name: 'font_size',
      desc: '',
      args: [],
    );
  }

  /// `Corners message's`
  String get corners_message {
    return Intl.message(
      'Corners message\'s',
      name: 'corners_message',
      desc: '',
      args: [],
    );
  }

  /// `Language settings`
  String get language_settings {
    return Intl.message(
      'Language settings',
      name: 'language_settings',
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

  /// `Продолжить`
  String get continue_button {
    return Intl.message(
      'Продолжить',
      name: 'continue_button',
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

  /// `Safe`
  String get safe_btn {
    return Intl.message(
      'Safe',
      name: 'safe_btn',
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
