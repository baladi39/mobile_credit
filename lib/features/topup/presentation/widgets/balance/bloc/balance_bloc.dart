import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';

import 'package:mobile_credit/features/topup/domain/usecases/financial/latest_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/financial/user_debit_post.dart';
import 'package:mobile_credit/features/topup/domain/usecases/financial/user_debit_pre.dart';
import 'package:mobile_credit/features/topup/domain/usecases/financial/user_debit_revert.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BalanceBloc extends Bloc<BalanceEvent, BalanceState> {
  final LatestFinancialSummary latestFinancialSummary;
  final UserDebitPre userDebitPre;
  final UserDebitPost userDebitPost;
  final UserDebitRevert userDebitRevert;

  BalanceBloc({
    required this.latestFinancialSummary,
    required this.userDebitPre,
    required this.userDebitPost,
    required this.userDebitRevert,
  }) : super(BalanceInitial()) {
    on<BalanceEvent>((event, emit) => emit(BalanceLoading()));
    on<GetBalanceEvent>((event, emit) async {
      var response = await latestFinancialSummary(event.userId);

      return response.fold(
        (l) => emit(BalanceFailer(l.message)),
        (r) => emit(BalanceSuccess(r)),
      );
    });

    /// Here, we focus on simulating a three-stage transaction flow :
    /// -Debited from user balance (Pending Transaction)
    /// -Credited to beneficiary
    /// -Update user's monthly spent (Proccessed Transaction)
    /// Each point can have a point of failure that needs to be handled

    /// Debiting the main balance
    on<UserDebitPreEvent>((event, emit) async {
      var response = await userDebitPre(event.userTopUpParam);
      response.fold(
        (l) {
          add(GetBalanceEvent(event.userTopUpParam.userId));
          emit(BalancePostingFailer(l.message));
        },
        (r) {
          emit(BalancePostingPending(event.userTopUpParam));
          emit(BalanceSuccess(r));
        },
      );
    });

    /// Updating the monthly spent
    on<UserDebitPostEvent>((event, emit) async {
      var response = await userDebitPost(event.userTopUpParam);
      response.fold(
        (l) {
          add(GetBalanceEvent(event.userTopUpParam.userId));
          emit(BalancePostingFailer(l.message));
        },
        (r) => emit(BalanceSuccess(r)),
      );
    });

    /// Reverting the entire transaction due to some failure
    on<UserDebitRevertEvent>((event, emit) async {
      var response = await userDebitRevert(event.userTopUpParam);
      response.fold(
        (l) {
          add(GetBalanceEvent(event.userTopUpParam.userId));
          emit(BalancePostingFailer(l.message));
        },
        (r) => emit(BalanceSuccess(r)),
      );
    });
  }
}
