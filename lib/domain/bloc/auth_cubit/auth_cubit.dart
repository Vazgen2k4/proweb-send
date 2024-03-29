import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proweb_send/domain/firebase/firebase_collections.dart';
import 'package:proweb_send/domain/providers/user_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends Equatable {
  final UserData user;
  final bool hasAuth;
  const AuthState({required this.hasAuth, required this.user});

  @override
  List<Object> get props => [hasAuth, user];

  AuthState copyWith({UserData? user, bool? hasAuth}) {
    return AuthState(
      hasAuth: hasAuth ?? this.hasAuth,
      user: user ?? this.user,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  // Способы авторизации
  final auth = FirebaseAuth.instance;
  // Контроллер для записи номера телефона
  final _userPhone = UserPhoneData();
  UserPhoneData get userPhone => _userPhone;
  // Управление данными пользователя
  final _userDataProvider = UserDataProvider();
  // Id для входа
  String _verificationId = '';

  // Передача состояния по умолчанию
  AuthCubit() : super(const AuthState(hasAuth: false, user: UserData())) {
    _initUser();
  }

  // Инициализация пользователя при входе и тд
  Future<void> _initUser() async {
    final user = await _userDataProvider.loadValue();
    final _pref = await SharedPreferences.getInstance();
    final _hasAuth = _pref.getBool(UserDataKeys.hasAuth) ?? false;
    final newState = state.copyWith(user: user, hasAuth: _hasAuth);
    emit(newState);
  }

  // Вход через телефон
  Future<void> authRequestWithPhone(
    BuildContext context, {
    String? phone,
  }) async {
    if (phone == null) return;
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (credential) async {
        authConfirmWithPhone(cred: credential);
      },
      verificationFailed: (e) {
        print(e.message);
      },
      codeSent: (String verificationID, int? resendToken) async {
        _verificationId = verificationID;
      },
      codeAutoRetrievalTimeout: (String verificationID) {},
    );
  }

  // Подтверждение номера телефона через смс
  // Так же возвращает значение того, нужно ли пользователью производить
  // регистрацию или нет
  Future<bool?> authConfirmWithPhone({PhoneAuthCredential? cred}) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: userPhone.smsController.value.text,
    );

    final _info = await auth.signInWithCredential(cred ?? credential);

    final _userInfo = _info.user;
    if (_userInfo == null) return null;

    return await FirebaseCollections.needRegistr(userId: _userInfo.uid);
  }

  // Выход с firebase аккаунта
  Future<void> logOut() async {
    try {
      await auth.signOut();
      final _pref = await SharedPreferences.getInstance();
      await _pref.clear();

      final newState = state.copyWith(
        user: const UserData(),
        hasAuth: false,
      );

      emit(newState);
    } catch (e) {
      print('object - log Out');
    }
  }

  @override
  Future<void> close() {
    userPhone.dispose();
    return super.close();
  }

  // Future<bool> _authCompleate(UserCredential _info) async {
  //   final _userInfo = _info.user;
  //   if (_userInfo == null) return false;

  //   final need = await FirebaseCollections.needRegistr(userId: _userInfo.uid);
  //   if (need) return true;

  // final newUser = state.user.copyWith(
  //   name: _userInfo.displayName,
  //   email: _userInfo.email,
  //   userName: _userInfo.email?.replaceAll('@gmail.com', ''),
  //   phone: _userInfo.phoneNumber,
  // );

  // await FirebaseCollections.addUserTo(
  //   userId: _userInfo.uid,
  //   userData: newUser.toJson(),
  // );

  // final _pref = await SharedPreferences.getInstance();
  // await _pref.setBool(UserDataKeys.hasAuth, true);

  // final newState = state.copyWith(
  //   user: newUser,
  //   hasAuth: true,
  // );

  // emit(newState);
  // }
}
