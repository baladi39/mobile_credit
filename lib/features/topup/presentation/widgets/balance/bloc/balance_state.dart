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

final class BalancePostingProccessed extends BalanceState {}

final class BalancePostingPending extends BalanceState {}

final class BalancePostingFailer extends BalanceState {
  final String meesage;
  const BalancePostingFailer(this.meesage);
}

final class BalanceFailer extends BalanceState {
  final String meesage;
  const BalanceFailer(this.meesage);
}
