import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/core/common/entities/user.dart';
import 'package:mobile_credit/features/auth/domain/usecases/current_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CurrentUser currentUser;
  final AppUserCubit appUserCubit;
  AuthBloc({
    required this.currentUser,
    required this.appUserCubit,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthLoginEvent>(onAuthLogin);
  }

  void onAuthLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    var response = await currentUser(event.isVerified);

    response.fold(
      (l) => emit(AuthFailure(l.toString())),
      (r) => emitAuthSuccess(r, emit),
    );
  }

  void emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
