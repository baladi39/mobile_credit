import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/features/topup/data/datasources/financial_remote_data_source.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';

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
  Future<Either<Failure, UserFinancialSummary>> postUserDebitPendTrans(
      int userId, double amount) async {
    try {
      final financialSummary =
          await remoteDataSource.postUserDebitPendTransData(userId, amount);

      return right(financialSummary);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserFinancialSummary>> postUserDebitTrans(
      int userId, double amount) async {
    try {
      final financialSummary =
          await remoteDataSource.postUserDebitTransData(userId, amount);

      return right(financialSummary);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserFinancialSummary>> postUserRevertDebitTrans(
      int userId, double amount) async {
    try {
      final financialSummary =
          await remoteDataSource.postUserDebitPendTransData(userId, amount);

      return right(financialSummary);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
