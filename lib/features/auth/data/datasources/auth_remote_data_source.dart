import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUserData(bool isUserVerified);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl();

  @override
  Future<UserModel?> getCurrentUserData(bool? isUserVerified) async {
    try {
      /// Pretend we are recieving json and we passed it to userModel.fromJson()
      if (isUserVerified == null) {
        return null;
      }
      if (isUserVerified) {
        return UserModel(
            id: 1,
            email: 'sally@yopmail.com',
            name: 'Sally Myers',
            isVerifed: true);
      } else {
        return UserModel(
            id: 2,
            email: 'carla@yopmail.com',
            name: 'Carla Cruz',
            isVerifed: false);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
