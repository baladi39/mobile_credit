import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary_credit.dart';
import 'package:mobile_credit/features/topup/domain/usecases/latest_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/user_debit.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final LatestFinancialSummary latestFinancialSummary;
  final UserDebit userDebit;
  final BeneficiaryCredit beneficiaryCredit;

  BalanceBloc({
    required this.latestFinancialSummary,
    required this.userDebit,
    required this.beneficiaryCredit,
  }) : super(BalanceInitial()) {
    on<BalanceEvent>((event, emit) => emit(BalanceLoading()));
    on<GetBalanceEvent>((event, emit) async {
      var response = await latestFinancialSummary(event.userId);

      return response.fold(
        (l) => emit(BalanceFailer(l.message)),
        (r) => emit(BalanceSuccess(r)),
      );
    });
    on<UserDebitEvent>((event, emit) async {
      var response = await userDebit(event.userTopUpParam);

      response.fold(
        (l) => emit(BalanceFailer(l.message)),
        (r) {
          emit(BalancePostingPending());
          return emit(BalanceSuccess(r));
        },
      );

      if (state is BalanceSuccess) {
        var response = await beneficiaryCredit(event.userTopUpParam);

        response.fold(
          (l) => emit(BalanceFailer(l.message)),
          (r) {
            emit(BalancePostingSuccess());
            return emit(BalanceSuccess(r));
          },
        );
      }

      /// usecase for update beneficiary
      // await Future.delayed(const Duration(seconds: 10));
      // emit(BalancePostingSuccess());
      // return emit(BalanceSuccess(
      //     UserFinancialSummary(totalBalance: 0, totalMonthlySpent: 0)));
    });
  }
}
