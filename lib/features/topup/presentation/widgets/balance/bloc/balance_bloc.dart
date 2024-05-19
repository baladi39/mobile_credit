import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';
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

    /// Streams (websockets or webhooks) could be used as future enhancment but streams are resource intensive and complex
    /// Here, we focus on simulating a three-stage transaction flow :
    /// -Debited from user balance (Pending Transaction)
    /// -Credited to beneficiary
    /// -Update user's monthly spent (Proccessed Transaction)
    /// Each point can have a point of failure that needs to be handled
    ///
    /// In order to simulate that user's balance is debited first and beneficiary credit second
    /// I wrote the code as such
    on<UserDebitEvent>((event, emit) async {
      var response = await userDebit(event.userTopUpParam);
      response.fold(
        (l) => emit(BalancePostingFailer(l.message)),
        (r) {
          emit(BalancePostingPending());
          emit(BalanceSuccess(r));
        },
      );

      if (state is BalanceSuccess) {
        var response = await beneficiaryCredit(event.userTopUpParam);
        response.fold(
          (l) => emit(BalancePostingFailer(l.message)),
          (r) {
            emit(BalancePostingProccessed());
            return emit(BalanceSuccess(r));
          },
        );
      }
    });
  }
}
