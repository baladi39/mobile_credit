import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';

abstract interface class FinancialRepository {
  Future<Either<Failure, UserFinancialSummary>> getFinancialSummary(int userId);
}
