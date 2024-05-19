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

final class UserDebitPreEvent extends BalanceEvent {
  final UserTopUpParam userTopUpParam;
  const UserDebitPreEvent(this.userTopUpParam);
}

final class UserDebitPostEvent extends BalanceEvent {
  final UserTopUpParam userTopUpParam;
  const UserDebitPostEvent(this.userTopUpParam);
}

final class UserDebitRevertEvent extends BalanceEvent {
  final UserTopUpParam userTopUpParam;
  const UserDebitRevertEvent(this.userTopUpParam);
}
