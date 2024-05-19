import 'package:mobile_credit/core/constants/constants.dart';
import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/topup/data/models/user_financial_summary_model.dart';

abstract interface class FinancialRemoteDataSource {
  Future<UserFinancialSummaryModel> getCurrentFinancialData(int userId);
  Future<UserFinancialSummaryModel> postUserDebitPendTransData(
      int userId, double amount);
  Future<UserFinancialSummaryModel> postUserRevertDebitTransData(
      int userId, double amount);
  Future<UserFinancialSummaryModel> postUserDebitTransData(
      int userId, double amount);
}

class FinancialRemoteDataSourceImpl implements FinancialRemoteDataSource {
  FinancialRemoteDataSourceImpl(
    /// Usually I would use the fakedatabase for testing ONLY but I am including here for demostration
    this.fakeDatebase,
  );

  final FakeDatebase fakeDatebase;

  @override
  Future<UserFinancialSummaryModel> getCurrentFinancialData(int userId) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 1));

    // Pretend we are recieving json from a remote database
    try {
      var userFin = fakeDatebase.usersFinSummary
          .where((a) => a['user_id'] == userId)
          .first;

      return UserFinancialSummaryModel.fromJson(userFin['financial_summary']);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserFinancialSummaryModel> postUserDebitPendTransData(
      int userId, double amount) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 2));

    // Pretend we are making api call and recieving json
    try {
      var userFin = fakeDatebase.usersFinSummary
          .where((a) => a['user_id'] == userId)
          .first;

      /// This logic should be in the backend
      double totalBalance = userFin['financial_summary']['total_balance'];

      if (totalBalance > (amount + Constants.transactionFee)) {
        double finalTotalBalance = userFin['financial_summary']
                ['total_balance'] -
            (amount + Constants.transactionFee);

        userFin['financial_summary'].update(
          'total_balance',
          (_) => finalTotalBalance,
        );
        return UserFinancialSummaryModel.fromJson(userFin['financial_summary']);
      }
      throw const ServerException('insufficient funds');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserFinancialSummaryModel> postUserDebitTransData(
      int userId, double amount) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 8));

    try {
      // Pretend we are making api call and recieving json
      var userFin = fakeDatebase.usersFinSummary
          .where((a) => a['user_id'] == userId)
          .first;

      /// This logic should be in the backend
      double finalTotalMonthlySpent =
          userFin['financial_summary']['total_monthly_spent'] + amount;

      userFin['financial_summary'].update(
        'total_monthly_spent',
        (_) => finalTotalMonthlySpent,
      );
      return UserFinancialSummaryModel.fromJson(userFin['financial_summary']);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserFinancialSummaryModel> postUserRevertDebitTransData(
      int userId, double amount) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      var userFin = fakeDatebase.usersFinSummary
          .where((a) => a['user_id'] == userId)
          .first;

      /// This logic should be in the backend
      double totalBalance = userFin['financial_summary']['total_balance'];

      double finalTotalBalance =
          totalBalance + (amount + Constants.transactionFee);

      userFin['financial_summary'].update(
        'total_balance',
        (_) => finalTotalBalance,
      );
      return UserFinancialSummaryModel.fromJson(userFin['financial_summary']);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
