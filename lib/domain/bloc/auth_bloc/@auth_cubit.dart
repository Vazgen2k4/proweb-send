import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  const AuthState({
    required this.hasAuth,
    required this.user,
  });

  @override
  List<Object> get props => [
        hasAuth,
        user,
      ];

  AuthState copyWith({
    UserData? user,
    bool? hasAuth,
    UserCreateErros? erros,
  }) {
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
  // Контроллер для записи номера телефона
  final _userCreate = UserCreateData();
  UserCreateData get userCreate => _userCreate;
  // Управление данными пользователя
  final _userDataProvider = UserDataProvider();
  // Id для входа
  String _verificationId = '';

  // Передача состояния по умолчанию
  AuthCubit()
      : super(const AuthState(
          hasAuth: false,
          user: UserData(),
        )) {
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
    try {
      final sms = userPhone.smsController.value.text.trim().replaceAll(' ', '');

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: sms,
      );

      final _info = await auth.signInWithCredential(cred ?? credential);

      final _userInfo = _info.user;
      if (_userInfo == null) return null;

      return await FirebaseCollections.needRegistr(userId: _userInfo.uid);
    } catch (e) {
      logOut();
      return null;
    }
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

  Future<void> createAccount() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    final data = UserData(
      name: _userCreate.nameController.value.text,
      userName: _userCreate.userNameController.value.text,
      descr: _userCreate.descrController.value.text,
      phone: _userPhone.phone,
    ).toJson();

    await FirebaseCollections.addUserTo(userId: uid, userData: data);

    final _pref = await SharedPreferences.getInstance();
    await _pref.setBool(UserDataKeys.hasAuth, true);
    emit(state.copyWith(hasAuth: true));
  }

  Future<UserCreateErros> checkErrors() async {
    final users = await FirebaseFirestore.instance
        .collection(FirebaseCollections.usersPath)
        .get();

    final nikNameId =
        _userCreate.userNameController.value.text.trim().replaceAll(' ', '_');
    final name =
        _userCreate.nameController.value.text.trim().replaceAll(' ', '_');

    final _userNameEmpty = nikNameId.isEmpty;
    final _nameEmpty = name.isEmpty;
    final _userNameBusy = users.docs.any((user) {
      return user.data()['nikNameId'] == nikNameId;
    });

    return UserCreateErros(
      nameEmpty: _nameEmpty,
      userNameBusy: _userNameBusy,
      userNameEmpty: _userNameEmpty,
    );
  }

  @override
  Future<void> close() {
    _userCreate.dispose();
    _userPhone.dispose();
    return super.close();
  }
}
