part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoad extends AuthEvent {
    
}

class AuthWithPhone extends AuthEvent {
  
}

class AuthWithGoogle extends AuthEvent {
  
}