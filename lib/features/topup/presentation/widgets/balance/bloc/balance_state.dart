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

  @override
  List<Object> get props => [userFinancialSummary];
}

final class BalanceDebitSuccess extends BalanceState {
  final UserFinancialSummary userFinancialSummary;
  const BalanceDebitSuccess(this.userFinancialSummary);

  @override
  List<Object> get props => [userFinancialSummary];
}

final class BalanceFailer extends BalanceState {
  final String meesage;
  const BalanceFailer(this.meesage);
}

final class BalancePostingPending extends BalanceState {
  final UserTopUpParam userTopUpParam;
  const BalancePostingPending(this.userTopUpParam);
}

final class BalancePostingFailer extends BalanceState {
  final String meesage;
  const BalancePostingFailer(this.meesage);
}
