import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/core/common/entities/user.dart';

void main() {
  group('updateUser()', () {
    var userTest = const User(
      id: 1,
      email: 'test@yopmail.com',
      name: 'Mr Test',
      isVerifed: true,
    );
    blocTest<AppUserCubit, AppUserState>(
      'emits [AppUserLoggedIn] when user logins and updateUser is called.',
      setUp: () {},
      build: () => AppUserCubit(),
      act: (cubit) => cubit.updateUser(userTest),
      expect: () => <AppUserState>[AppUserLoggedIn(userTest)],
    );
    blocTest<AppUserCubit, AppUserState>(
      'emits [AppUserInitial] when app is first intialized.',
      setUp: () {},
      build: () => AppUserCubit(),
      act: (cubit) => cubit.updateUser(null),
      expect: () => <AppUserState>[AppUserInitial()],
    );
  });
}
