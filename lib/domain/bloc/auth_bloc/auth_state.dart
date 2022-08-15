part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoaded extends AuthState {
  static final auth = FirebaseAuth.instance;
  static PhoneAuthCredential? credential;
  static String? verificationid;
  static final userController = ProUserController();

  final bool hasAuth;
  final bool needRegister;
  final ProUser user;
  final ProUserErros erros;

  const AuthLoaded({
    required this.hasAuth,
    required this.needRegister,
    required this.user,
    required this.erros,
  });

  @override
  List<Object> get props => [hasAuth, user, needRegister, erros];

  AuthLoaded copyWith({
    bool? hasAuth,
    bool? needRegister,
    ProUser? user,
    ProUserErros? erros,
  }) {
    return AuthLoaded(
      hasAuth: hasAuth ?? this.hasAuth,
      user: user ?? this.user,
      needRegister: needRegister ?? this.needRegister,
      erros: erros ?? this.erros,
    );
  }
}
