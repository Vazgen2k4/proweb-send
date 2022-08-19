// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/models/pro_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoadAuth>(_loadAuth);
    on<AuthWithPhone>(_authWithPhone);
    on<AuthVerifirePhone>(_authVerifirePhone);
    // on<AuthCreateAccount>(_authCreateAccount);
    on<AuthCreateCheckErrorsAndRegister>(_authCreateCheckErrorsAndRegister);
    on<AuthLogOut>((_, emit) => _logOut(emit));
  }

  Future<void> _loadAuth(
    LoadAuth event,
    Emitter<AuthState> emit,
  ) async {
    final auth = FirebaseAuth.instance.currentUser;
    print(auth?.uid);

    final _hasAuth = auth != null;
    final needRegister =
        await FirebaseCollections.needRegistr(userId: auth?.uid);

    final need = needRegister ?? false;

    if (need) {
      await Future.delayed(
        const Duration(seconds: 5),
      );
    }

    final _user = !need
        ? ProUser.fromJson((await FirebaseFirestore.instance
                .collection(FirebaseCollections.usersPath)
                .doc(auth?.uid)
                .get())
            .data())
        : ProUser(id: auth?.uid);

    emit(
      AuthLoaded(
        hasAuth: _hasAuth,
        user: _user,
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
      print(AuthLoaded.userController.phone);
      await AuthLoaded.auth.verifyPhoneNumber(
        phoneNumber: AuthLoaded.userController.phone,
        timeout: const Duration(minutes: 2),
        verificationCompleted: (credential) async {
          AuthLoaded.credential = credential;
        },
        verificationFailed: (e) {
          print('=' * 91);
          print(e.message);
          print('=' * 19);
          event.onFailed != null ? event.onFailed!() : 0;
        },
        codeSent: (String verificationID, int? resendToken) async {
          AuthLoaded.verificationid = verificationID;
          print('[object] - send code');
          print(AuthLoaded.verificationid);
          event.onSuccess != null ? event.onSuccess!() : 0;
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          print('time out');
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
      // Только для (Android), Если телефон сам прочитал sms код
      final authCredential = AuthLoaded.credential;
      if (authCredential != null) {
        final userCredential =
            await AuthLoaded.auth.signInWithCredential(authCredential);

        final needRegister = await FirebaseCollections.needRegistr(
            userId: userCredential.user?.uid);

        final newState = state.copyWith(
          hasAuth: true,
          user: state.user.copyWith(
            id: userCredential.user?.uid,
            phone: AuthLoaded.userController.phone,
          ),
          needRegister: needRegister,
        );
        AuthLoaded.userController.uid = newState.user.id;

        emit(newState);

        event.onSuccess != null ? event.onSuccess!() : 0;
        return;
      }

      // Если был введен код в ручную)
      final verId = AuthLoaded.verificationid;
      if (verId != null) {
        final sms = AuthLoaded.userController.smsController.value.text;
        print(sms.replaceAll(' ', ''));

        final cred = PhoneAuthProvider.credential(
          verificationId: verId,
          smsCode: sms.replaceAll(' ', ''),
        );

        final userCredential = await AuthLoaded.auth.signInWithCredential(cred);

        print("id ---- ${userCredential.user?.uid}");

        final needRegister = await FirebaseCollections.needRegistr(
            userId: userCredential.user?.uid);

        final curentUser = needRegister == false
            ? ProUser.fromJson((await FirebaseFirestore.instance
                    .collection(FirebaseCollections.usersPath)
                    .doc(userCredential.user?.uid)
                    .get())
                .data())
            : state.user;

        final newState = state.copyWith(
          hasAuth: true,
          user: curentUser.copyWith(
            id: userCredential.user?.uid,
            phone: AuthLoaded.userController.phone,
          ),
          needRegister: needRegister,
        );
        AuthLoaded.userController.uid = newState.user.id;

        print(newState.user.nikNameId);
        print(newState.user.name);
        print(newState.user.phone);

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

      final _userController = AuthLoaded.userController;
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

      final curentUser = newState.user.copyWith(
        name: _name,
        nikNameId: _nikName,
        descr: _userController.descrController.value.text.trim(),
        imagePath: imgUrl,
      );

      final uid = AuthLoaded.auth.currentUser?.uid;

      await FirebaseCollections.addUserTo(
        userId: uid,
        userData: curentUser.toJson(),
      );

      emit(newState.copyWith(
        user: curentUser,
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

      await AuthLoaded.auth.signOut();

      final newState = state.copyWith(
        hasAuth: false,
        user: const ProUser(),
      );

      print('object - log Out');

      AuthLoaded.userController.clear();
      emit(newState);
    } catch (e) {
      print('object - log Out');
    }
  }
}
