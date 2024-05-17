import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/topup/data/models/user_financial_summary_model.dart';

abstract interface class FinancialRemoteDataSource {
  Future<UserFinancialSummaryModel> getCurrentFinancialData(int userId);
  Future<UserFinancialSummaryModel> postUserDebitPendTransData(
      int userId, int beneficiaryId, double amount);
  Future<UserFinancialSummaryModel> postUserDebitTransData(
      int userId, int beneficiaryId, double amount);
}

class FinancialRemoteDataSourceImpl implements FinancialRemoteDataSource {
  FinancialRemoteDataSourceImpl(
    this.fakeDatebase,
  );

  final FakeDatebase fakeDatebase;

  @override
  Future<UserFinancialSummaryModel> getCurrentFinancialData(int userId) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Pretend we are recieving json
      if (userId == 1) {
        return fakeDatebase.userOneFinancialSummary;
      } else {
        return fakeDatebase.userTwoFinancialSummary;
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserFinancialSummaryModel> postUserDebitPendTransData(
      int userId, int beneficiaryId, double amount) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Pretend we are making api call and recieving json
      if (userId == 1) {
        var finalTotalBalance =
            fakeDatebase.userOneFinancialSummary.totalBalance - amount;
        // Transaction would be pending
        var finalMonthlySpent =
            fakeDatebase.userOneFinancialSummary.totalMonthlySpent;

        return fakeDatebase.userOneFinancialSummary = UserFinancialSummaryModel(
          totalBalance: finalTotalBalance,
          totalMonthlySpent: finalMonthlySpent,
        );
      } else {
        var finalTotalBalance =
            fakeDatebase.userTwoFinancialSummary.totalBalance - amount;
        // Transaction would be pending
        var finalMonthlySpent =
            fakeDatebase.userTwoFinancialSummary.totalMonthlySpent;

        return fakeDatebase.userTwoFinancialSummary = UserFinancialSummaryModel(
          totalBalance: finalTotalBalance,
          totalMonthlySpent: finalMonthlySpent,
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserFinancialSummaryModel> postUserDebitTransData(
      int userId, int beneficiaryId, double amount) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 8));

    try {
      // Pretend we are making api call and recieving json
      if (userId == 1) {
        // Already debited
        var finalTotalBalance =
            fakeDatebase.userOneFinancialSummary.totalBalance;
        var finalMonthlySpent =
            fakeDatebase.userOneFinancialSummary.totalMonthlySpent + amount;

        return fakeDatebase.userOneFinancialSummary = UserFinancialSummaryModel(
          totalBalance: finalTotalBalance,
          totalMonthlySpent: finalMonthlySpent,
        );
      } else {
        // Already debited
        var finalTotalBalance =
            fakeDatebase.userTwoFinancialSummary.totalBalance;
        var finalMonthlySpent =
            fakeDatebase.userTwoFinancialSummary.totalMonthlySpent + amount;

        return fakeDatebase.userTwoFinancialSummary = UserFinancialSummaryModel(
          totalBalance: finalTotalBalance,
          totalMonthlySpent: finalMonthlySpent,
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
