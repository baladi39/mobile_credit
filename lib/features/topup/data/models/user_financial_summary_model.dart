import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';

class UserFinancialSummaryModel extends UserFinancialSummary {
  UserFinancialSummaryModel({
    required super.totalBalance,
    required super.totalMonthlySpent,
  });

  // Methods for converting to and from JSON format, currently not used due to mocked responses.
  factory UserFinancialSummaryModel.fromJson(Map<String, dynamic> map) {
    return UserFinancialSummaryModel(
      totalBalance: map['total_balance'] ?? '',
      totalMonthlySpent: map['total_monthly_spent'] ?? '',
    );
  }

  @override
  UserFinancialSummaryModel copyWith({
    double? totalBalance,
    double? totalMonthlySpent,
  }) {
    return UserFinancialSummaryModel(
      totalBalance: totalBalance ?? this.totalBalance,
      totalMonthlySpent: totalMonthlySpent ?? this.totalMonthlySpent,
    );
  }
}
