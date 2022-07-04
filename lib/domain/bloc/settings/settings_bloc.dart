import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/generated/l10n.dart';

part 'settings_bloc_event.dart';
part 'settings_bloc_state.dart';

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  SettingsBloc() : super(SettingsBlocInitial()) {
    // Ивент загрузки настроек
    on<LoadSettings>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1));

      emit(event.loded);
    });

    // Переключение языка
    on<SwitchLanguage>((event, emit) async {
      if (state is SettingsBlocLoded) {
        final state = this.state as SettingsBlocLoded;

        await S.load(event.language);

        emit(
          SettingsBlocLoded(
            language: event.language,
            theme: state.theme,
            user: state.user,
          ),
        );
      }
    });
    // Установка темы
    on<SetTheme>((event, emit) {
      if (state is SettingsBlocLoded) {
        final state = this.state as SettingsBlocLoded;

        final _theme = state.theme;

        final _newTheme = SettingsThemeOptions(
          bgImgUrl: _theme.bgImgUrl,
          fontSize: _theme.fontSize,
          messageRadius: _theme.messageRadius,
          isDark: event.isDark,
        );

        emit(
          SettingsBlocLoded(
            language: state.language,
            theme: _newTheme,
            user: state.user,
          ),
        );
      }
    });
    // Установка фона
    on<SetBgUrl>((event, emit) {
      if (state is SettingsBlocLoded) {
        final state = this.state as SettingsBlocLoded;
        final _theme = state.theme;

        final _newTheme = SettingsThemeOptions(
          bgImgUrl: event.bgImgUrl,
          fontSize: _theme.fontSize,
          messageRadius: _theme.messageRadius,
          isDark: _theme.isDark,
        );

        emit(
          SettingsBlocLoded(
            language: state.language,
            theme: _newTheme,
            user: state.user,
          ),
        );
      }
    });
    // Установка радиуса угов сообщений
    on<SetBorderRadius>((event, emit) {
      if (state is SettingsBlocLoded) {
        final state = this.state as SettingsBlocLoded;

        final _theme = state.theme;

        final _newTheme = SettingsThemeOptions(
          bgImgUrl: _theme.bgImgUrl,
          fontSize: _theme.fontSize,
          messageRadius: event.messageRadius,
          isDark: _theme.isDark,
        );

        emit(
          SettingsBlocLoded(
            language: state.language,
            theme: _newTheme,
            user: state.user,
          ),
        );
      }
    });
    // Установка размера шрифта
    on<SetFontSize>((event, emit) {
      if (state is SettingsBlocLoded) {
        final state = this.state as SettingsBlocLoded;

        final _theme = state.theme;

        final _newTheme = SettingsThemeOptions(
          bgImgUrl: _theme.bgImgUrl,
          fontSize: event.fontSize,
          messageRadius: _theme.messageRadius,
          isDark: _theme.isDark,
        );

        emit(
          SettingsBlocLoded(
            language: state.language,
            theme: _newTheme,
            user: state.user,
          ),
        );
      }
    });
  }
}
