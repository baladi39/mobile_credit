import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/latest_financial_summary.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final LatestFinancialSummary currentFinancialSummary;

  /// This Bloc is used to mimic a database for user financial data in this example.
  /// In a real application, a proper database solution would be implemented.
  final UserFinancialSummary userFinancialSummary = UserFinancialSummary(
    totalBalance: 0,
    totalMonthlySpent: 0,
  );

  BalanceBloc({
    required this.currentFinancialSummary,
  }) : super(BalanceInitial()) {
    on<BalanceEvent>((event, emit) => emit(BalanceLoading()));
    on<GetBalanceEvent>((event, emit) async {
      var response = await currentFinancialSummary(event.userId);

      return response.fold(
        (l) => emit(BalanceFailer(l.message)),
        (r) {
          userFinancialSummary.copyWith(
            totalBalance: r.totalBalance,
            totalMonthlySpent: r.totalMonthlySpent,
          );
          emit(BalanceSuccess(r.totalBalance, r.totalMonthlySpent));
        },
      );
    });
  }
}
