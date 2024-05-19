import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/common/parameters/user_topup_param.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/user_financial_summary.dart';

import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';
import 'package:mobile_credit/features/topup/domain/repository/financial_repository.dart';
import 'package:mobile_credit/features/topup/domain/usecases/add_beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary_credit.dart';
import 'package:mobile_credit/features/topup/domain/usecases/latest_beneficiaries.dart';
import 'package:mobile_credit/features/topup/domain/usecases/latest_financial_summary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/user_debit_post.dart';
import 'package:mobile_credit/features/topup/domain/usecases/user_debit_pre.dart';
import 'package:mobile_credit/features/topup/domain/usecases/user_debit_revert.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/beneficiary/bloc/beneficiary_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBeneRepository extends Mock implements BeneficiaryRepository {}

class MockFinRepository extends Mock implements FinancialRepository {}

void main() {
  late MockBeneRepository beneRepository;
  late MockFinRepository finRepository;
  late BalanceBloc balanceBloc;
  late BeneficiaryBloc beneficiaryBloc;

  setUp(() {
    beneRepository = MockBeneRepository();
    finRepository = MockFinRepository();
    var latestFinancialSummary = LatestFinancialSummary(finRepository);
    var userDebitPre = UserDebitPre(finRepository);
    var beneficiaryCredit = BeneficiaryCredit(beneRepository);
    var latestBeneficiaries = LatestBeneficiaries(beneRepository);
    var userDebitPost = UserDebitPost(finRepository);
    var userDebitRevert = UserDebitRevert(finRepository);
    var addBeneficiary = AddBeneficiary(beneRepository);

    beneficiaryBloc = BeneficiaryBloc(
        latestBeneficiaries: latestBeneficiaries,
        addBeneficiary: addBeneficiary,
        beneficiaryCredit: beneficiaryCredit);

    balanceBloc = BalanceBloc(
      latestFinancialSummary: latestFinancialSummary,
      userDebitPre: userDebitPre,
      beneficiaryBloc: beneficiaryBloc,
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
        BalanceSuccess,
        BalancePostingPending,
        BalancePostingProccessed,
        BalanceSuccess] when UserDebitEvent is added and transaction approved.''',
      build: () {
        when(() => finRepository.postUserDebitPre(1, 100))
            .thenAnswer((_) async => right(userPendTrans));
        // when(() => beneRepository.postBeneficiaryCredit(1, 100, 100))
        //     .thenAnswer((_) async => right(true));
        when(() => finRepository.postUserDebitPost(1, 100))
            .thenAnswer((_) async => right(userApprTrans));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitPreEvent(UserTopUpParam(1, 100, 100))),
      expect: () => <BalanceState>[
        BalanceLoading(),
        BalancePostingPending(),
        BalanceSuccess(userPendTrans),
        BalanceSuccess(userApprTrans),
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalancePostingFailer] when UserDebitEvent is added and debit transaction api failed.''',
      build: () {
        when(() => finRepository.postUserDebitPre(1, 100))
            .thenAnswer((_) async => left(Failure()));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitPreEvent(UserTopUpParam(1, 100, 100))),
      expect: () => <BalanceState>[
        BalanceLoading(),
        const BalancePostingFailer(apiErrorMessage),
      ],
    );

    blocTest<BalanceBloc, BalanceState>(
      '''emits [
        BalanceLoading,
        BalancePostingPending,
        BalanceSuccess,
        BalancePostingProccessed,
        BalanceSuccess] when UserDebitEvent is added and credit beneficiary transaction api failed.''',
      build: () {
        when(() => finRepository.postUserDebitPre(1, 100))
            .thenAnswer((_) async => right(userPendTrans));
        when(() => beneRepository.postBeneficiaryCredit(1, 100, 100))
            .thenAnswer((_) async => left(Failure()));
        // when(() => finRepository.postUserRevertDebitTrans(1, 100))
        //     .thenAnswer((_) async => right(userIntTrans));
        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitPreEvent(UserTopUpParam(1, 100, 100))),
      expect: () => <BalanceState>[
        BalanceLoading(),
        BalancePostingPending(),
        BalanceSuccess(userPendTrans),
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
        when(() => finRepository.postUserDebitPre(1, 100))
            .thenAnswer((_) async => right(userPendTrans));
        // when(() => beneRepository.postBeneficiaryCredit(1, 100, 100))
        //     .thenAnswer((_) async => right(true));
        when(() => finRepository.postUserDebitPost(1, 100))
            .thenAnswer((_) async => left(Failure()));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitPreEvent(UserTopUpParam(1, 100, 100))),
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
        when(() => finRepository.postUserDebitPre(1, 100))
            .thenAnswer((_) async => right(userPendTrans));
        // when(() => beneRepository.postBeneficiaryCredit(1, 100, 100))
        //     .thenAnswer((_) async => right(true));
        when(() => finRepository.postUserDebitPost(1, 100))
            .thenAnswer((_) async => left(Failure()));

        return balanceBloc;
      },
      act: (bloc) => bloc.add(UserDebitPreEvent(UserTopUpParam(1, 100, 100))),
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
