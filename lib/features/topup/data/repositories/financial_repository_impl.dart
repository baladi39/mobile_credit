import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/features/topup/data/datasources/financial_remote_data_source.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';
import 'package:mobile_credit/features/topup/domain/usecases/spend_user_credit.dart';

import '../../../../core/error/failures.dart';

class FinancialRepositoryImpl implements FinancialRepository {
  final FinancialRemoteDataSource remoteDataSource;

  const FinancialRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<Either<Failure, UserFinancialSummary>> getFinancialSummary(
      int userId) async {
    try {
      final financialSummary =
          await remoteDataSource.getCurrentFinancialData(userId);

      return right(financialSummary);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserFinancialSummary>> postBeneficiaryCreditTrans(
      UserSpendCreditParam userSpendCreditParam) async {
    try {
      final financialSummary =
          await remoteDataSource.postBeneficiaryCreditTransData(
              userSpendCreditParam.userId,
              userSpendCreditParam.beneficiaryId,
              userSpendCreditParam.amount);

      return right(financialSummary);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
