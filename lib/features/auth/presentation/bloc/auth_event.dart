part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthLoginEvent extends AuthEvent {
  final int userId;

  const AuthLoginEvent({
    required this.userId,
  });
}

final class AuthIsUserLoggedInEvent extends AuthEvent {}
