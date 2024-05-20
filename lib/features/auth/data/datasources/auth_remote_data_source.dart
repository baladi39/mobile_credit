import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUserData(int userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Usually I would use the fakedatabase for testing ONLY but I am including here for demostration
  /// So I created fake database which is implemented to a test database
  AuthRemoteDataSourceImpl(this.fakeDatebase);

  final FakeDatebase fakeDatebase;

  @override
  Future<UserModel?> getCurrentUserData(int userId) async {
    try {
      var user = fakeDatebase.users.where((a) => a['user_id'] == userId).first;
      UserModel.fromJson(user);
    } catch (e) {
      throw ServerException(e.toString());
    }
    return null;
  }
}
