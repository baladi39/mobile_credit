part of 'balance_bloc.dart';

sealed class BalanceEvent extends Equatable {
  const BalanceEvent();

  @override
  List<Object> get props => [];
}

final class GetBalanceEvent extends BalanceEvent {
  final int userId;
  const GetBalanceEvent(this.userId);
}

final class SpendUserCreditEvent extends BalanceEvent {
  final UserSpendCreditParam userSpendCreditParam;
  const SpendUserCreditEvent(this.userSpendCreditParam);
}
