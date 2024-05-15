import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/entities/user.dart';
import 'package:mobile_credit/core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> currentUser(bool isVerifed);
}
