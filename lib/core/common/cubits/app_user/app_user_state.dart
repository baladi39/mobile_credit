part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;
  AppUserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}
