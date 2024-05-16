import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';

abstract interface class FinancialRemoteDataSource {
  Future<UserFinancialSummary> getCurrentFinancialData(int userId);
}

class FinancialRemoteDataSourceImpl implements FinancialRemoteDataSource {
  FinancialRemoteDataSourceImpl(
    this.fakeDatebase,
  );

  final FakeDatebase fakeDatebase;

  @override
  Future<UserFinancialSummary> getCurrentFinancialData(int userId) async {
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
}
