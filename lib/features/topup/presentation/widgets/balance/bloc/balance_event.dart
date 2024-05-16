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

// final class UpdateBalanceEvent extends BalanceEvent {
//   final int userId;
//   const UpdateBalanceEvent(this.userId);
// }
