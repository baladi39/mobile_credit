import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/latest_financial_summary.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final LatestFinancialSummary latestFinancialSummary;

  BalanceBloc({
    required this.latestFinancialSummary,
  }) : super(BalanceInitial()) {
    on<BalanceEvent>((event, emit) => emit(BalanceLoading()));
    on<GetBalanceEvent>((event, emit) async {
      var response = await latestFinancialSummary(event.userId);

      return response.fold(
        (l) => emit(BalanceFailer(l.message)),
        (r) => emit(BalanceSuccess(r)),
      );
    });
  }
}
