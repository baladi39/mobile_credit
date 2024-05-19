import 'package:equatable/equatable.dart';

class UserFinancialSummary extends Equatable {
  final double totalBalance;
  final double totalMonthlySpent;

  const UserFinancialSummary({
    required this.totalBalance,
    required this.totalMonthlySpent,
  });

  @override
  List<Object?> get props => [totalBalance, totalMonthlySpent];
}
