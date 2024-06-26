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
  Future<Either<Failure, UserFinancialSummary>> postUserDebitPre(
      int userId, double amount) async {
    try {
      final financialSummary =
          await remoteDataSource.postUserDebitPreTransData(userId, amount);

      return right(financialSummary);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserFinancialSummary>> postUserDebitPost(
      int userId, double amount) async {
    try {
      final financialSummary =
          await remoteDataSource.postUserDebitPostTransData(userId, amount);

      return right(financialSummary);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserFinancialSummary>> postUserDebitRevert(
      int userId, double amount) async {
    try {
      final financialSummary =
          await remoteDataSource.postUserDebitPreTransData(userId, amount);

      return right(financialSummary);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
