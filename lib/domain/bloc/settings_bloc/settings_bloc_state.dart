part of 'settings_bloc.dart';

abstract class SettingsBlocState extends Equatable {
  const SettingsBlocState();

  @override
  List<Object?> get props => [];
}

class SettingsBlocInitial extends SettingsBlocState {}

class SettingsBlocLoded extends SettingsBlocState {
  final SettingsModel settings;
  final ProUser user;
  const SettingsBlocLoded({required this.settings, required this.user});

  @override
  List<Object?> get props => [settings, user];

  SettingsBlocLoded copyWith({
    SettingsModel? settings,
    ProUser? user,
  }) {
    return SettingsBlocLoded(
      settings: settings ?? this.settings,
      user: user ?? this.user,
    );
  }
}
