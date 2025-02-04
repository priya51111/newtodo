import 'package:equatable/equatable.dart';

enum SigninStatus { initial, loading, loaded, error, loggedIn }

final class SigninState extends Equatable {
  const SigninState({
    this.status = SigninStatus.initial,
    this.user,
    this.message,
  });
  final SigninStatus status;
  final Map<String, dynamic>? user;
  final String? message;

  static SigninState initial =
      const SigninState(status: SigninStatus.initial, message: '', user: {});

  SigninState copyWith({
    SigninStatus? status,
    Map<String, dynamic>? user,
    String? message,
  }) {
    return SigninState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        message,
      ];
}

final class ViewRendererInitial extends SigninState {}
