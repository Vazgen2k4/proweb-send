part of 'settings_bloc.dart';

abstract class SettingsBlocEvent extends Equatable {
  const SettingsBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsBlocEvent {
  final SettingsBlocLoded loded;

  const LoadSettings(this.loded);

  @override
  List<Object?> get props => [loded];
}

class SwitchLanguage extends SettingsBlocEvent {
  final Locale language;

  const SwitchLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

class SetTheme extends SettingsBlocEvent {
  final bool isDark;

  const SetTheme(this.isDark);

  @override
  List<Object?> get props => [isDark];
}

class SetFontSize extends SettingsBlocEvent {
  final double fontSize;

  const SetFontSize(this.fontSize);

  @override
  List<Object?> get props => [fontSize];
}

class SetBorderRadius extends SettingsBlocEvent {
  final double messageRadius;

  const SetBorderRadius(this.messageRadius);

  @override
  List<Object?> get props => [messageRadius];
}

class SetBgUrl extends SettingsBlocEvent {
  final String bgImgUrl;

  const SetBgUrl(this.bgImgUrl);

  @override
  List<Object?> get props => [bgImgUrl];
}
