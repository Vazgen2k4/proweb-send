part of 'settings_bloc.dart';

abstract class SettingsBlocState extends Equatable {
  const SettingsBlocState();

  @override
  List<Object?> get props => [];
}

class SettingsBlocInitial extends SettingsBlocState {}

class SettingsBlocLoded extends SettingsBlocState {

  const SettingsBlocLoded();

  @override
  List<Object?> get props => [];
}
