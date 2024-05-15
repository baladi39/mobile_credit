part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthLoginEvent extends AuthEvent {
  final bool isVerified;

  const AuthLoginEvent({
    required this.isVerified,
  });
}

final class AuthIsUserLoggedInEvent extends AuthEvent {}
