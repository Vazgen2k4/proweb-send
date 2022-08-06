import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proweb_send/domain/providers/user_data_provider.dart';

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
    final newState = state.copyWith(user: user);
    emit(newState);
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

  Future<void> authWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final authData = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: authData.accessToken,
        idToken: authData.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      print(userCredential.user?.displayName);

    } catch (e) {
      print('Произошла ошибка');
    }
  }
}
