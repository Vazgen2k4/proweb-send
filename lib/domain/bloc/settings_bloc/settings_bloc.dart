import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/domain/models/settings_model.dart';

part 'settings_bloc_event.dart';
part 'settings_bloc_state.dart';

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      _subStream;

  SettingsBloc() : super(SettingsBlocInitial()) {
    on<LoadSettings>(_loadSettings);
    on<SetFontSize>(_setFontSize);
    on<SetBorderRadius>(_setBorderRadius);
    on<SetLocale>(_setLocale);

    final uid = FirebaseAuth.instance.currentUser?.uid;

    _stream = FirebaseFirestore.instance
        .collection(FirebaseCollections.usersPath)
        .doc(uid)
        .snapshots();

    _subStream = _stream.listen((_) => add(const LoadSettings()));
  }

  Future<void> _loadSettings(
    LoadSettings event,
    Emitter<SettingsBlocState> emit,
  ) async {
    final settngs = await SettingsModel.getSettingsOnDevice();
    final userDoc = await _stream.first;

    emit(
      SettingsBlocLoded(
        settings: settngs,
        user: ProUser.fromJson(userDoc.data()),
      ),
    );
  }

  Future<void> _setFontSize(
    SetFontSize event,
    Emitter<SettingsBlocState> emit,
  ) async {
    if (this.state is! SettingsBlocLoded) return;

    final state = this.state as SettingsBlocLoded;
    final fontSize = event.fontSize;

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          fontSize: fontSize,
        ),
      ),
    );
  }

  Future<void> _setBorderRadius(
    SetBorderRadius event,
    Emitter<SettingsBlocState> emit,
  ) async {
    if (this.state is! SettingsBlocLoded) return;

    final state = this.state as SettingsBlocLoded;
    final radius = event.borderRadius;

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          borderRadius: radius,
        ),
      ),
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
      state.copyWith(
        settings: state.settings.copyWith(
          locale: locale,
        ),
      ),
    );
  }

  // Future<void> _setUserData(
  //   SetUserData event,
  //   Emitter<SettingsBlocState> emit,
  // ) async {
  //   if (this.state is! SettingsBlocLoded) return;

  //   final state = this.state as SettingsBlocLoded;

  //   emit(
  //     SettingsBlocLoded(

  //     ),
  //   );
  // }

  @override
  Future<void> close() {
    _subStream.cancel();
    return super.close();
  }
}
