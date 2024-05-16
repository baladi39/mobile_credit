import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/features/topup/domain/usecases/current_financial_summary.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final CurrentFinancialSummary currentFinancialSummary;
  BalanceBloc({
    required this.currentFinancialSummary,
  }) : super(BalanceInitial()) {
    on<BalanceEvent>((event, emit) => emit(BalanceLoading()));
    on<GetBalanceEvent>((event, emit) async {
      var response = await currentFinancialSummary(event.userId);

      return response.fold(
        (l) => emit(BalanceFailer(l.message)),
        (r) => emit(BalanceSuccess(r.totalBalance, r.totalMonthlySpent)),
      );
    });
  }
}
