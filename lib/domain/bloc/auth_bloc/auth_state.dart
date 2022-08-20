part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoaded extends AuthState {
  final bool hasAuth;
  final bool needRegister;
  final ProUserErros erros;

  const AuthLoaded({
    required this.hasAuth,
    required this.needRegister,
    required this.erros,
  });

  @override
  List<Object> get props => [hasAuth,  needRegister, erros];

  AuthLoaded copyWith({
    bool? hasAuth,
    bool? needRegister,
    ProUserErros? erros,
  }) {
    return AuthLoaded(
      hasAuth: hasAuth ?? this.hasAuth,
      needRegister: needRegister ?? this.needRegister,
      erros: erros ?? this.erros,
    );
  }
}
