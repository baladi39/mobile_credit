import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/entities/user.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<User, int> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(int userId) async {
    return await authRepository.currentUser(userId);
  }
}
