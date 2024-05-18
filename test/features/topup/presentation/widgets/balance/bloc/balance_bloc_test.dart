import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';

import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary_credit.dart';
import 'package:mobile_credit/features/topup/domain/usecases/latest_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/user_debit.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBeneRepository extends Mock implements BeneficiaryRepository {}

class MockFinRepository extends Mock implements FinancialRepository {}

void main() {
  late MockBeneRepository beneRepository;
  late MockFinRepository finRepository;
  late BalanceBloc balanceBloc;
  late LatestFinancialSummary latestFinancialSummary;
  late UserDebit userDebit;
  late BeneficiaryCredit beneficiaryCredit;

  setUp(() {
    beneRepository = MockBeneRepository();
    finRepository = MockFinRepository();
    latestFinancialSummary = LatestFinancialSummary(finRepository);
    userDebit = UserDebit(finRepository);
    beneficiaryCredit = BeneficiaryCredit(finRepository, beneRepository);

    balanceBloc = BalanceBloc(
      latestFinancialSummary: latestFinancialSummary,
      userDebit: userDebit,
      beneficiaryCredit: beneficiaryCredit,
    );
  });

  group('onGetBalanceEvent', () {
    var userFinancialSummaryTest = UserFinancialSummary(
      totalBalance: 1000,
      totalMonthlySpent: 100,
    );

    blocTest<BalanceBloc, BalanceState>(
      'emits [BalanceLoading, BalanceSuccess] when GetBalanceEvent is added.',
      build: () {
        when(() => finRepository.getFinancialSummary(1))
            .thenAnswer((_) async => right(userFinancialSummaryTest));
        return balanceBloc;
      },
      act: (bloc) => bloc.add(const GetBalanceEvent(1)),
      expect: () => <BalanceState>[
        BalanceLoading(),
        BalanceSuccess(userFinancialSummaryTest)
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      'emits [BalanceLoading, BalanceFailer] when GetBalanceEvent is added with failure.',
      build: () {
        when(() => finRepository.getFinancialSummary(1))
            .thenAnswer((_) async => left(Failure()));
        return balanceBloc;
      },
      act: (bloc) => bloc.add(const GetBalanceEvent(1)),
      expect: () => <BalanceState>[
        BalanceLoading(),
        const BalanceFailer('An unexpected error occurred')
      ],
    );
  });

  group('onUserDebitEvent', () {
    var userIntTrans = UserFinancialSummary(
      totalBalance: 1000,
      totalMonthlySpent: 100,
    );
    var userPendTrans = UserFinancialSummary(
      totalBalance: 900,
      totalMonthlySpent: 100,
    );
    var userApprTrans = UserFinancialSummary(
      totalBalance: 900,
      totalMonthlySpent: 200,
    );
    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalanceSuccess,
        BalancePostingPending,
        BalancePostingProccessed,
        BalanceSuccess] when UserDebitEvent is added and transaction approved.''',
      build: () {
        when(() => finRepository.postUserDebitPendTrans(1, 100))
            .thenAnswer((_) async => right(userPendTrans));
        when(() => beneRepository.postBeneficiaryCredit(1, 100, 100))
            .thenAnswer((_) async => right(true));
        when(() => finRepository.postUserDebitTrans(1, 100))
            .thenAnswer((_) async => right(userApprTrans));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitEvent(UserTopUpParam(1, 100, 100))),
      expect: () => <BalanceState>[
        BalanceLoading(),
        BalancePostingPending(),
        BalanceSuccess(userPendTrans),
        BalancePostingProccessed(),
        BalanceSuccess(userApprTrans),
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalancePostingFailer] when UserDebitEvent is added and debit transaction failed.''',
      build: () {
        when(() => finRepository.postUserDebitPendTrans(1, 100))
            .thenAnswer((_) async => left(Failure()));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitEvent(UserTopUpParam(1, 100, 100))),
      expect: () => <BalanceState>[
        BalanceLoading(),
        const BalancePostingFailer('An unexpected error occurred'),
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalancePostingPending,
        BalanceSuccess,
        BalancePostingProccessed
        BalanceSuccess
] when UserDebitEvent is added and credit beneficiary transaction failed.''',
      build: () {
        when(() => finRepository.postUserDebitPendTrans(1, 100))
            .thenAnswer((_) async => right(userPendTrans));
        when(() => beneRepository.postBeneficiaryCredit(1, 100, 100))
            .thenAnswer((_) async => left(Failure()));
        when(() => finRepository.postUserRevertDebitTrans(1, 100))
            .thenAnswer((_) async => right(userIntTrans));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitEvent(UserTopUpParam(1, 100, 100))),
      expect: () => <BalanceState>[
        BalanceLoading(),
        BalancePostingPending(),
        BalanceSuccess(userPendTrans),
        BalancePostingProccessed(),
        BalanceSuccess(userIntTrans),
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalancePostingPending,
        BalanceSuccess,
        BalancePostingFailer] when UserDebitEvent is added and update user monthlySpent failed.''',
      build: () {
        when(() => finRepository.postUserDebitPendTrans(1, 100))
            .thenAnswer((_) async => right(userPendTrans));
        when(() => beneRepository.postBeneficiaryCredit(1, 100, 100))
            .thenAnswer((_) async => right(true));
        when(() => finRepository.postUserDebitTrans(1, 100))
            .thenAnswer((_) async => left(Failure()));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitEvent(UserTopUpParam(1, 100, 100))),
      expect: () => <BalanceState>[
        BalanceLoading(),
        BalancePostingPending(),
        BalanceSuccess(userPendTrans),
        const BalancePostingFailer('An unexpected error occurred'),
      ],
    );
  });
}
