part of 'balance_bloc.dart';

sealed class BalanceState extends Equatable {
  const BalanceState();

  @override
  List<Object> get props => [];
}

final class BalanceInitial extends BalanceState {}

final class BalanceLoading extends BalanceState {}

final class BalanceSuccess extends BalanceState {
  final UserFinancialSummary userFinancialSummary;

  const BalanceSuccess(this.userFinancialSummary);
}

final class BalanceFailer extends BalanceState {
  final String meesage;
  const BalanceFailer(this.meesage);
}
