import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final bool isAuth;
  const Auth(this.isAuth);
  
  @override
  List<Object?> get props => [isAuth]; 
}