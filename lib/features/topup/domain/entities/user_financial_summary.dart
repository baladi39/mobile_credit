class UserFinancialSummary {
  final double totalBalance;
  final double totalMonthlySpent;

  UserFinancialSummary({
    required this.totalBalance,
    required this.totalMonthlySpent,
  });

  UserFinancialSummary copyWith({
    double? totalBalance,
    double? totalMonthlySpent,
  }) {
    return UserFinancialSummary(
      totalBalance: totalBalance ?? this.totalBalance,
      totalMonthlySpent: totalMonthlySpent ?? this.totalMonthlySpent,
    );
  }
}
