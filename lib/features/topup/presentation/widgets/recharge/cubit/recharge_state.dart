part of 'recharge_cubit.dart';

sealed class RechargeState extends Equatable {
  final int topUpOptionValue;
  const RechargeState(this.topUpOptionValue);

  @override
  List<Object> get props => [topUpOptionValue];
}

final class RechargeInitial extends RechargeState {
  const RechargeInitial(super.topUpOptionValue);
}

final class RechargeLoaded extends RechargeState {
  const RechargeLoaded(super.topUpOptionValue);
}
