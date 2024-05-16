import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';

abstract interface class FinancialRepository {
  Future<Either<Failure, UserFinancialSummary>> getFinancialSummary(int userId);

  /// We would typically add another function to post a transaction for the beneficiary.
  /// However, since we're currently storing data within the Bloc for demonstration purposes,
  /// this functionality is not implemented here. In a real application, transactions would
  /// be persisted in a proper database.
  // Future<Either<Failure, UserFinancialSummary>> postTransaction(
  //     int userId, int beneficiaryId, double amount);
}
