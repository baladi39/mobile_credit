import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';
import 'package:mobile_credit/features/topup/domain/usecases/financial/latest_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/financial/user_debit_post.dart';
import 'package:mobile_credit/features/topup/domain/usecases/financial/user_debit_pre.dart';
import 'package:mobile_credit/features/topup/domain/usecases/financial/user_debit_revert.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';

import 'package:mocktail/mocktail.dart';

class MockBeneRepository extends Mock implements BeneficiaryRepository {}

class MockFinRepository extends Mock implements FinancialRepository {}

void main() {
  late MockFinRepository finRepository;
  late BalanceBloc balanceBloc;

  setUp(() {
    finRepository = MockFinRepository();
    var latestFinancialSummary = LatestFinancialSummary(finRepository);
    var userDebitPre = UserDebitPre(finRepository);
    var userDebitPost = UserDebitPost(finRepository);
    var userDebitRevert = UserDebitRevert(finRepository);

    balanceBloc = BalanceBloc(
      latestFinancialSummary: latestFinancialSummary,
      userDebitPre: userDebitPre,
      userDebitPost: userDebitPost,
      userDebitRevert: userDebitRevert,
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
        BalancePostingPending,
        BalanceSuccess] when UserDebitEvent is added and transaction approved.''',
      build: () {
        when(() => finRepository.postUserDebitPre(
                userTopUpParam.userId, userTopUpParam.amount))
            .thenAnswer((_) async => right(userPendTrans));

        /// Beneficiary credit is presumed to success

        when(() => finRepository.postUserDebitPost(
                userTopUpParam.userId, userTopUpParam.amount))
            .thenAnswer((_) async => right(userApprTrans));
        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitPreEvent(userTopUpParam)),
      expect: () => <BalanceState>[
        BalanceLoading(),
        BalancePostingPending(userTopUpParam),
        BalanceSuccess(userPendTrans),
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalancePostingFailer] when UserDebitEvent is added and debit transaction api failed.''',
      build: () {
        when(() => finRepository.postUserDebitPre(
                userTopUpParam.userId, userTopUpParam.amount))
            .thenAnswer((_) async => left(Failure()));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitPreEvent(userTopUpParam)),
      expect: () => <BalanceState>[
        BalanceLoading(),
        const BalancePostingFailer(apiErrorMessage),
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalancePostingFailer] when UserDebitEvent is added with lack of funds.''',
      build: () {
        when(() => finRepository.postUserDebitPre(
                userTopUpParam.userId, userTopUpParam.amount))
            .thenAnswer((_) async => left(Failure('Insufficient funds')));
        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitPreEvent(userTopUpParam)),
      expect: () => <BalanceState>[
        BalanceLoading(),
        const BalancePostingFailer('Insufficient funds'),
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
var userTopUpParam = UserTopUpParam(1, 100, 100);
