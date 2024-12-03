abstract class SigninEvent {}

class CreateUser extends SigninEvent {
  final String email;
  final String password;

  CreateUser({required this.email, required this.password});
}

class LoginUser extends SigninEvent {
  final String email;
  final String password;

  LoginUser({required this.email, required this.password});
}

