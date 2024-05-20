import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/entities/user.dart';
import 'package:mobile_credit/core/error/exceptions.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, User>> currentUser(int userId) async {
    try {
      final user = await remoteDataSource.getCurrentUserData(userId);
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
