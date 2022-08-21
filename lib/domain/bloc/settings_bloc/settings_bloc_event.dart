part of 'settings_bloc.dart';

abstract class SettingsBlocEvent extends Equatable {
  const SettingsBlocEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsBlocEvent {
  const LoadSettings();
  
}

// class LoadSettings extends SettingsBlocEvent {
//   const LoadSettings();
// }

