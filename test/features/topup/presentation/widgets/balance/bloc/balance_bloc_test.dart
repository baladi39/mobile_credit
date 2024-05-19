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

  setUp(() {
    beneRepository = MockBeneRepository();
    finRepository = MockFinRepository();
    var latestFinancialSummary = LatestFinancialSummary(finRepository);
    var userDebit = UserDebit(finRepository);
    var beneficiaryCredit = BeneficiaryCredit(finRepository, beneRepository);

    balanceBloc = BalanceBloc(
      latestFinancialSummary: latestFinancialSummary,
      userDebit: userDebit,
      beneficiaryCredit: beneficiaryCredit,
    );
  });

  group('onGetBalanceEvent', () {
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
      'emits [BalanceLoading, BalanceFailer] when GetBalanceEvent is added with api failure.',
      build: () {
        when(() => finRepository.getFinancialSummary(1))
            .thenAnswer((_) async => left(Failure()));
        return balanceBloc;
      },
      act: (bloc) => bloc.add(const GetBalanceEvent(1)),
      expect: () => <BalanceState>[
        BalanceLoading(),
        const BalanceFailer(apiErrorMessage)
      ],
    );
  });

  group('onUserDebitEvent', () {
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
        BalancePostingFailer] when UserDebitEvent is added and debit transaction api failed.''',
      build: () {
        when(() => finRepository.postUserDebitPendTrans(1, 100))
            .thenAnswer((_) async => left(Failure()));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitEvent(UserTopUpParam(1, 100, 100))),
      expect: () => <BalanceState>[
        BalanceLoading(),
        const BalancePostingFailer(apiErrorMessage),
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalanceValidationErrro] when UserDebitEvent is added and credit beneficiary transaction api failed.''',
      build: () => balanceBloc,
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
        BalancePostingFailer] when UserDebitEvent is added and update user monthlySpent api failed.''',
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
        const BalancePostingFailer(apiErrorMessage),
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalancePostingPending,
        BalanceSuccess,
        BalancePostingFailer] when UserDebitEvent is added with lack of funds.''',
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
        const BalancePostingFailer(apiErrorMessage),
      ],
    );
  });
}

var userFinancialSummaryTest = const UserFinancialSummary(
  totalBalance: 1000,
  totalMonthlySpent: 100,
);

var userIntTrans = const UserFinancialSummary(
  totalBalance: 1000,
  totalMonthlySpent: 100,
);
var userPendTrans = const UserFinancialSummary(
  totalBalance: 900,
  totalMonthlySpent: 100,
);
var userApprTrans = const UserFinancialSummary(
  totalBalance: 900,
  totalMonthlySpent: 200,
);

const apiErrorMessage = 'An unexpected error occurred';
