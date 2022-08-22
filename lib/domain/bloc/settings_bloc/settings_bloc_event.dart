part of 'settings_bloc.dart';

abstract class SettingsBlocEvent extends Equatable {
  const SettingsBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsBlocEvent {
  const LoadSettings();
}

class SetBorderRadius extends SettingsBlocEvent {
  final double borderRadius;
  const SetBorderRadius({required this.borderRadius});

  @override
  List<Object?> get props => [borderRadius];
}

class SetFontSize extends SettingsBlocEvent {
  final double fontSize;
  const SetFontSize({required this.fontSize});

  @override
  List<Object?> get props => [fontSize];
}

class SetLocale extends SettingsBlocEvent {
  final String locale;
  const SetLocale({required this.locale});

  @override
  List<Object?> get props => [locale];
}
