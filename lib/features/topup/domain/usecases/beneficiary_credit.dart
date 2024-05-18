import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';

import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';

class BeneficiaryCredit
    implements UseCase<UserFinancialSummary, UserTopUpParam> {
  final FinancialRepository financialRepository;
  final BeneficiaryRepository beneficiaryRepository;
  BeneficiaryCredit(this.financialRepository, this.beneficiaryRepository);

  // Need to seperate this in 2 usecases
  // UserMonthlyCredit & BeneficiaryCredit
  @override
  Future<Either<Failure, UserFinancialSummary>> call(
      UserTopUpParam userTopUpParam) async {
    var response = await beneficiaryRepository.postBeneficiaryCredit(
      userTopUpParam.userId,
      userTopUpParam.beneficiaryId,
      userTopUpParam.amount,
    );

    return response.fold((_) async {
      // Revert changes
      return await financialRepository.postUserRevertDebitTrans(
        userTopUpParam.userId,
        userTopUpParam.amount,
      );
    }, (_) async {
      // Proceed as normal
      return await financialRepository.postUserDebitTrans(
        userTopUpParam.userId,
        userTopUpParam.amount,
      );
    });
  }
}
