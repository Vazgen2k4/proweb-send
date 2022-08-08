import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  // Управление данными пользователя
  final _userDataProvider = UserDataProvider();
  // Авторизация через гугл
  final _googleSignIn = GoogleSignIn();

  AuthCubit() : super(const AuthState(hasAuth: false, user: UserData())) {
    _initUser();
  }

  Future<void> _initUser() async {
    final user = await _userDataProvider.loadValue();
    final _pref = await SharedPreferences.getInstance();

    final _hasAuth = _pref.getBool(UserDataKeys.hasAuth) ?? false;

    final newState = state.copyWith(user: user, hasAuth: _hasAuth);
    emit(newState);
  }

  // Авторизация через гугл
  Future<void> authWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final authData = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: authData.accessToken,
        idToken: authData.idToken,
      );

      final _info = await FirebaseAuth.instance.signInWithCredential(cred);
      final _userDetails = _info.user;

      if (_userDetails == null) return;

      final newUser = state.user.copyWith(
        name: _userDetails.displayName,
        email: _userDetails.email,
        userName: _userDetails.email?.replaceAll('@gmail.com', ''),
        phone: _userDetails.phoneNumber,
      );

      final _pref = await SharedPreferences.getInstance();
      const _hasAuth = true;
      await _pref.setBool(UserDataKeys.hasAuth, _hasAuth);

      final newState = state.copyWith(
        user: newUser,
        hasAuth: _hasAuth,
      );

      await Firebasecollections.addUserTo(
        userId: _userDetails.uid,
        userData: newUser.toJson(),
      );

      emit(newState);
    } catch (e) {
      print('Произошла ошибка');
      logOutWithGoogle();
    }
  }

  Future<void> logOutWithGoogle() async {
    try {
      await _googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
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
}


















  // Future<void> authWithPhone({String? phone}) async {
  //   if(phone == null) return;
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     verificationCompleted: (credential) async {
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //       print('is auth');
  //     },
  //     verificationFailed: (e) {
  //       print(e.message);
  //     },
  //     codeSent: (String verificationID, int? resendToken) {
  //       _code = verificationID;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationID) {
  //       _code = verificationID;
  //     },
  //   );
  // }
