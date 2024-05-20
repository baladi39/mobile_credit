import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_credit/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile_credit/features/auth/data/models/user_model.dart';

import '../../../../test_database.dart';

void main() {
  late AuthRemoteDataSourceImpl authRemoteDataSource;
  late TestDatebase testDatebase;

  setUp(() {
    testDatebase = TestDatebase();
    authRemoteDataSource = AuthRemoteDataSourceImpl(testDatebase);
  });

  group('GetCurrentUserData', () {
    test('Getting the signed in user postive scenario', () async {
      // Arrange
      var testUserId = 1;
      var userExpected = const UserModel(
        id: 1,
        email: 'sally@yopmail.com',
        name: 'Sally Myers',
        isVerifed: true,
      );
      // Act
      var result = await authRemoteDataSource.getCurrentUserData(testUserId);
      // Assert
      expect(result, userExpected);
    });
  });
}
