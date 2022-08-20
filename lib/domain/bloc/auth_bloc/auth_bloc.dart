import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/pro_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String? userBlocVerificationId;
  PhoneAuthCredential? userBlocCredential;
  final auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<LoadAuth>(_loadAuth);
    on<AuthWithPhone>(_authWithPhone);
    on<AuthVerifirePhone>(_authVerifirePhone);
    on<AuthCreateCheckErrorsAndRegister>(_authCreateCheckErrorsAndRegister);
    on<AuthLogOut>((_, emit) => _logOut(emit));
  }

  Future<void> _loadAuth(
    LoadAuth event,
    Emitter<AuthState> emit,
  ) async {
    final auth = FirebaseAuth.instance.currentUser;

    final _hasAuth = auth != null;
    final needRegister =
        await FirebaseCollections.needRegistr(userId: auth?.uid);

    final need = needRegister ?? false;

    if (need) {
      await Future.delayed(
        const Duration(seconds: 5),
      );
    }

    emit(
      AuthLoaded(
        hasAuth: _hasAuth,
        needRegister: need,
        erros: const ProUserErros(),
      ),
    );
  }

  Future<void> _authWithPhone(
    AuthWithPhone event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthLoaded) return;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: ProUser.controller.phone,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (credential) async {
          userBlocCredential = credential;
        },
        verificationFailed: (e) {
          event.onFailed != null ? event.onFailed!() : 0;
        },
        codeSent: (String verificationID, int? resendToken) async {
          userBlocVerificationId = verificationID;
          event.onSuccess != null ? event.onSuccess!() : 0;
        },
        codeAutoRetrievalTimeout: (String verificationID) {
        },
      );
    } catch (e) {
      await _logOut(emit);
    }
  }

  Future<void> _authVerifirePhone(
    AuthVerifirePhone event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (this.state is! AuthLoaded) return;
      final state = this.state as AuthLoaded;

      final authCredential = userBlocCredential;
      if (authCredential != null) {
        final userCredential = await auth.signInWithCredential(authCredential);

        final needRegister = await FirebaseCollections.needRegistr(
          userId: userCredential.user?.uid,
        );

        final newState = state.copyWith(
          hasAuth: true,
          needRegister: needRegister,
        );

        emit(newState);

        event.onSuccess != null ? event.onSuccess!() : 0;
        return;
      }

      // Если был введен код в ручную)
      final verId = userBlocVerificationId;
      if (verId != null) {
        final sms = ProUser.controller.smsController.value.text;

        final cred = PhoneAuthProvider.credential(
          verificationId: verId,
          smsCode: sms.replaceAll(' ', ''),
        );

        final userCredential = await auth.signInWithCredential(cred);

        final needRegister = await FirebaseCollections.needRegistr(
          userId: userCredential.user?.uid,
        );

        final newState = state.copyWith(
          hasAuth: true,
          needRegister: needRegister,
        );

        emit(newState);
        event.onSuccess != null ? event.onSuccess!() : 0;
        return;
      }

      event.onFailed != null ? event.onFailed!() : 0;
    } catch (e) {
      event.onFailed != null ? event.onFailed!() : 0;

      await _logOut(emit);
    }
  }

  Future<void> _authCreateCheckErrorsAndRegister(
    AuthCreateCheckErrorsAndRegister event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (state is! AuthLoaded) return;

      final newState = state as AuthLoaded;

      final _userController = ProUser.controller;
      final _name =
          _userController.nameController.value.text.replaceAll(' ', '');
      final _nikName =
          _userController.userNikNameController.value.text.replaceAll(' ', '');

      final isBusy = await FirebaseCollections.busyNikName(nikNameId: _nikName);

      final _errors = ProUserErros(
        nameEmpty: _name.isEmpty,
        userNameEmpty: _nikName.isEmpty,
        userNameBusy: isBusy,
      );

      if (_errors.hasErrors) {
        emit(newState.copyWith(erros: _errors));
        return;
      }

      final imgFile = _userController.img;

      String? imgUrl;

      if (imgFile != null) {
        final path = 'users/avatars/$_nikName';
        final ref = FirebaseStorage.instance.ref().child(path);
        final file = File(imgFile.path!);
        await ref.putFile(file);

        imgUrl = await ref.getDownloadURL();
      }

      final curentUser = ProUser(
        phone: ProUser.controller.phone,
        name: _name,
        nikNameId: _nikName,
        descr: _userController.descrController.value.text.trim(),
        imagePath: imgUrl,
      );

      final uid = auth.currentUser?.uid;

      await FirebaseCollections.addUserTo(
        userId: uid,
        userData: curentUser.toJson(),
      );

      emit(newState.copyWith(
        erros: _errors,
        hasAuth: true,
        needRegister: false,
      ));

      event.onSuccess != null ? event.onSuccess!() : 0;
    } catch (e) {
      _logOut(emit);
    }
  }

  Future<void> _logOut(Emitter<AuthState> emit) async {
    try {
      if (this.state is! AuthLoaded) return;
      final state = this.state as AuthLoaded;

      await auth.signOut();

      final newState = state.copyWith(hasAuth: false);

      ProUser.controller.clear();
      emit(newState);
    } catch (e) {
      // ignore: avoid_print
      print('Error [object] - log Out');
    }
  }
}
