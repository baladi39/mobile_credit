import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';

import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';

class UserDebitRevert implements UseCase<UserFinancialSummary, UserTopUpParam> {
  final FinancialRepository financialRepository;
  UserDebitRevert(this.financialRepository);

  @override
  Future<Either<Failure, UserFinancialSummary>> call(
      UserTopUpParam userTopUpParam) async {
    return await financialRepository.postUserDebitRevert(
      userTopUpParam.userId,
      userTopUpParam.amount,
    );
  }
}
