import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/spend_user_credit.dart';

abstract interface class FinancialRepository {
  Future<Either<Failure, UserFinancialSummary>> getFinancialSummary(int userId);

  Future<Either<Failure, UserFinancialSummary>> postBeneficiaryCreditTrans(
      UserSpendCreditParam userSpendCreditParam);
}
