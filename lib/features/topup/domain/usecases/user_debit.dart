import 'package:fpdart/fpdart.dart';

import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';

class UserDebit implements UseCase<UserFinancialSummary, UserTopUpParam> {
  final FinancialRepository financialRepository;
  UserDebit(this.financialRepository);

  @override
  Future<Either<Failure, UserFinancialSummary>> call(
      UserTopUpParam userTopUpParam) async {
    return await financialRepository.postUserDebitPendTrans(
      userTopUpParam.userId,
      userTopUpParam.beneficiaryId,
      userTopUpParam.amount,
    );
  }
}

class UserTopUpParam {
  final int userId;
  final int beneficiaryId;
  final double amount;

  UserTopUpParam(
    this.userId,
    this.beneficiaryId,
    this.amount,
  );
}
