import 'package:fpdart/fpdart.dart';

import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';

class SpendUserCredit
    implements UseCase<UserFinancialSummary, UserSpendCreditParam> {
  final FinancialRepository financialRepository;
  SpendUserCredit(this.financialRepository);

  @override
  Future<Either<Failure, UserFinancialSummary>> call(
      UserSpendCreditParam userSpendCreditParam) async {
    return await financialRepository
        .postBeneficiaryCreditTrans(userSpendCreditParam);
  }
}

class UserSpendCreditParam {
  final int userId;
  final int beneficiaryId;
  final double amount;

  UserSpendCreditParam(
    this.userId,
    this.beneficiaryId,
    this.amount,
  );
}
