part of 'settings_bloc.dart';

abstract class SettingsBlocState extends Equatable {
  const SettingsBlocState();

  @override
  List<Object?> get props => [];
}

class SettingsBlocInitial extends SettingsBlocState {}

class SettingsBlocLoded extends SettingsBlocState {
  final SettingsModel settings;
  const SettingsBlocLoded({required this.settings});

  @override
  List<Object?> get props => [settings];

  SettingsBlocLoded copyWith({SettingsModel? settings}) {
    return SettingsBlocLoded(
      settings: settings ?? this.settings,
    );
  }
}
