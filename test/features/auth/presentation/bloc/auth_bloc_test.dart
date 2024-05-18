import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/core/common/entities/user.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/auth/domain/repository/auth_repository.dart';
import 'package:mobile_credit/features/auth/domain/usecases/current_user.dart';
import 'package:mobile_credit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthBloc authBloc;
  late CurrentUser currentUser;
  late AppUserCubit appUserCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    currentUser = CurrentUser(mockAuthRepository);
    appUserCubit = AppUserCubit();

    authBloc = AuthBloc(
      currentUser: currentUser,
      appUserCubit: appUserCubit,
    );
  });

  group('onAuthLogin', () {
    final userTest = User(
      id: 1,
      email: 'test@yopmail.com',
      name: 'Mr Test',
      isVerifed: true,
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when AuthLoginEvent is added with verified user.',
      build: () {
        when(() => mockAuthRepository.currentUser(true))
            .thenAnswer((_) async => right(userTest));
        return authBloc;
      },
      act: (bloc) async => bloc.add(const AuthLoginEvent(isVerified: true)),
      expect: () => <AuthState>[AuthLoading(), AuthSuccess(userTest)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when AuthLoginEvent is added failed authentication',
      build: () {
        when(() => mockAuthRepository.currentUser(true))
            .thenAnswer((_) async => left(Failure()));
        return authBloc;
      },
      act: (bloc) async => bloc.add(const AuthLoginEvent(isVerified: true)),
      expect: () => <AuthState>[
        AuthLoading(),
        const AuthFailure('An unexpected error occurred')
      ],
    );
  });
}
