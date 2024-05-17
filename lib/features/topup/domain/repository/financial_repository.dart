import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';

abstract interface class FinancialRepository {
  Future<Either<Failure, UserFinancialSummary>> getFinancialSummary(int userId);

  /// Passing the beneficiaryId for logging purposes and add it to transaction table
  Future<Either<Failure, UserFinancialSummary>> postUserDebitTrans(
      int userId, int beneficiaryId, double amount);

  /// Passing the beneficiaryId for logging purposes add it to transaction table
  Future<Either<Failure, UserFinancialSummary>> postUserDebitPendTrans(
      int userId, int beneficiaryId, double amount);
}
