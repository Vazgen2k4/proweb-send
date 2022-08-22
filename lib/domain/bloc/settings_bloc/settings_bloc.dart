import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:proweb_send/domain/models/settings_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

part 'settings_bloc_event.dart';
part 'settings_bloc_state.dart';

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  SettingsBloc() : super(SettingsBlocInitial()) {
    on<LoadSettings>(_loadSettings);
    on<SetFontSize>(_setFontSize);
    on<SetBorderRadius>(_setBorderRadius);
    on<SetLocale>(_setLocale);
  }

  Future<void> _loadSettings(
    LoadSettings event,
    Emitter<SettingsBlocState> emit,
  ) async {
    final settngs = await SettingsModel.getSettingsOnDevice();

    emit(SettingsBlocLoded(settings: settngs));
  }

  Future<void> _setFontSize(
    SetFontSize event,
    Emitter<SettingsBlocState> emit,
  ) async {
    if (this.state is! SettingsBlocLoded) return;

    final state = this.state as SettingsBlocLoded;
    final fontSize = event.fontSize;
    final double value = fontSize >= 12 && fontSize <= 22 ? fontSize : 16;

    emit(SettingsBlocLoded(settings: state.settings.copyWith(fontSize: value)));
  }

  Future<void> _setBorderRadius(
    SetBorderRadius event,
    Emitter<SettingsBlocState> emit,
  ) async {
    if (this.state is! SettingsBlocLoded) return;

    final state = this.state as SettingsBlocLoded;
    final fontSize = event.borderRadius;
    final double value = fontSize >= 12 && fontSize <= 22 ? fontSize : 16;

    emit(
      SettingsBlocLoded(settings: state.settings.copyWith(borderRadius: value)),
    );
  }

  Future<void> _setLocale(
    SetLocale event,
    Emitter<SettingsBlocState> emit,
  ) async {
    if (this.state is! SettingsBlocLoded) return;

    final state = this.state as SettingsBlocLoded;
    final locale = Locale(event.locale);

    emit(
      SettingsBlocLoded(
        settings: state.settings.copyWith(
          locale: locale,
        ),
      ),
    );
  }
}
