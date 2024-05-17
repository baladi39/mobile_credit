import 'package:fpdart/fpdart.dart';

import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/core/usecase/usecase.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';
import 'package:mobile_credit/features/topup/domain/usecases/user_debit.dart';

class BeneficiaryCredit
    implements UseCase<UserFinancialSummary, UserTopUpParam> {
  final FinancialRepository financialRepository;
  final BeneficiaryRepository beneficiaryRepository;
  BeneficiaryCredit(this.financialRepository, this.beneficiaryRepository);

  @override
  Future<Either<Failure, UserFinancialSummary>> call(
      UserTopUpParam userTopUpParam) async {
    // await beneficiaryRepository.postBeneficiaryCreditTrans(
    //   userSpendCreditParam.userId,
    //   userSpendCreditParam.beneficiaryId,
    //   userSpendCreditParam.amount,
    // );
    return await financialRepository.postUserDebitTrans(
      userTopUpParam.userId,
      userTopUpParam.beneficiaryId,
      userTopUpParam.amount,
    );
  }
}
