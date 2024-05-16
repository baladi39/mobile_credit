import 'package:mobile_credit/core/error/exceptions.dart';

import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';

abstract interface class FinancialRemoteDataSource {
  Future<UserFinancialSummary> getCurrentFinancialData(int userId);
}

class FinancialRemoteDataSourceImpl implements FinancialRemoteDataSource {
  FinancialRemoteDataSourceImpl();

  @override
  Future<UserFinancialSummary> getCurrentFinancialData(int userId) async {
    // Simmulating api call delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Pretend we are recieving json
      if (userId == 1) {
        return UserFinancialSummary(
          totalBalance: 4000.20,
          totalMonthlySpent: 100,
        );
      } else {
        return UserFinancialSummary(
          totalBalance: 5201.05,
          totalMonthlySpent: 1000,
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
