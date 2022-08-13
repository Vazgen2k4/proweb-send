import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:proweb_send/domain/models/pro_user.dart';
import 'package:proweb_send/domain/providers/user_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoadAuth>(_loadAuth);
    on<AuthWithPhone>(_authWithPhone);
    on<AuthVerifirePhone>(_authVerifirePhone);
    on<AuthCreateAccount>(_authCreateAccount);
    on<AuthLogInAccount>(_authLogInAccount);
  }

  Future<void> _loadAuth(
    LoadAuth event,
    Emitter<AuthState> emit,
  ) async {
    final auth = FirebaseAuth.instance.currentUser;
    final pref = await SharedPreferences.getInstance();

    final _hasAuth = pref.getBool(UserDataKeys.hasAuth);

    emit(AuthLoaded(hasAuth: _hasAuth ?? false, user: const ProUser()));
  }

  Future<void> _authWithPhone(
    AuthWithPhone event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoaded) {
      await AuthLoaded.auth.verifyPhoneNumber(
        phoneNumber: event.phone,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (credential) async {
          AuthLoaded.credential = credential;
        },
        verificationFailed: (e) {
          print('=' * 19);
          print(e.message);
          print('=' * 19);
        },
        codeSent: (String verificationID, int? resendToken) async {
          AuthLoaded.verificationid = verificationID;
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
      );
    }
  }

  Future<void> _authVerifirePhone(
    AuthVerifirePhone event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthLoaded) {
      final state = this.state as AuthLoaded;
      final authCredential = AuthLoaded.credential;
      if (authCredential != null) {
        await AuthLoaded.auth.signInWithCredential(authCredential);
        return;
      }

      final verId = AuthLoaded.verificationid;

      if (verId != null) {
        final cred = PhoneAuthProvider.credential(
          verificationId: verId,
          smsCode: event.sms,
        );

         await AuthLoaded.auth.signInWithCredential(cred);
      }
    }
  }

  Future<void> _authCreateAccount(
    AuthCreateAccount event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _authLogInAccount(
    AuthLogInAccount event,
    Emitter<AuthState> emit,
  ) async {}
}
