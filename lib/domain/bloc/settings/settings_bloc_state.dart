part of 'settings_bloc.dart';

abstract class SettingsBlocState extends Equatable {
  const SettingsBlocState();

  @override
  List<Object?> get props => [];
}

class SettingsBlocInitial extends SettingsBlocState {}

class SettingsBlocLoded extends SettingsBlocState {
  final Locale language;
  final SettingsThemeOptions theme;
  final SettingsUserOptions? user;

  const SettingsBlocLoded({
    required this.theme,
    required this.language,
    this.user,
  });

  @override
  List<Object?> get props => [language, theme, user];
}

class SettingsThemeOptions {
  final bool isDark;
  final String? bgImgUrl;
  final double messageRadius;
  final double fontSize;

  const SettingsThemeOptions({
    this.isDark = false,
    this.bgImgUrl,
    this.messageRadius = 5,
    this.fontSize = 19,
  });
}

class SettingsUserOptions {
  final String? id;
  final SettingsPhone phone;
  final String? name;
  final String? descr;
  final String? email;

  const SettingsUserOptions({
    required this.phone,
    this.id,
    this.name,
    this.descr,
    this.email,
  });
}

class SettingsPhone {
  final String? number;
  final String? code;

  const SettingsPhone({this.number, this.code});
}
