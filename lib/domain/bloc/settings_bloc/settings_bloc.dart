// import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_bloc_event.dart';
part 'settings_bloc_state.dart';

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  SettingsBloc() : super(SettingsBlocInitial()) {
    // on<Sett>((event, emit) => null)
  }


  // Future<void> _loadSettings(emin)
}
