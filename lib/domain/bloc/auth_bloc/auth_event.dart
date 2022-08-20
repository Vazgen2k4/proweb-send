part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoadAuth extends AuthEvent {
  const LoadAuth();

  @override
  List<Object?> get props => [];
}

class AuthWithPhone extends AuthEvent {
  final VoidCallback? onSuccess;
  final VoidCallback? onFailed;
  const AuthWithPhone({this.onSuccess, this.onFailed});

  @override
  List<Object?> get props => [onFailed, onSuccess];
}

class AuthVerifirePhone extends AuthEvent {
  final VoidCallback? onSuccess;
  final VoidCallback? onFailed;
  const AuthVerifirePhone({this.onSuccess, this.onFailed});

  @override
  List<Object?> get props => [onFailed, onSuccess];
}

class AuthCreateCheckErrorsAndRegister extends AuthEvent {
  final VoidCallback? onSuccess;
  const AuthCreateCheckErrorsAndRegister({this.onSuccess});

  @override
  List<Object?> get props => [onSuccess];
}

class AuthLogOut extends AuthEvent {
  const AuthLogOut();

  @override
  List<Object?> get props => [];
}
