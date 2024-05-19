import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_credit/core/error/failures.dart';
import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/repository/beneficiary_repository.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary/add_beneficiary.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary/beneficiary_credit.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary/latest_beneficiaries.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/beneficiary/bloc/beneficiary_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBeneRepository extends Mock implements BeneficiaryRepository {}

void main() {
  late MockBeneRepository beneRepository;
  late BeneficiaryBloc beneficiaryBloc;

  setUp(() {
    beneRepository = MockBeneRepository();

    var latestBeneficiaries = LatestBeneficiaries(beneRepository);
    var addBeneficiary = AddBeneficiary(beneRepository);
    var beneficiaryCredit = BeneficiaryCredit(beneRepository);
    beneficiaryBloc = BeneficiaryBloc(
      latestBeneficiaries: latestBeneficiaries,
      addBeneficiary: addBeneficiary,
      beneficiaryCredit: beneficiaryCredit,
    );
  });

  group('onGetBeneficiariesEvent', () {
    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'emits [BeneficiaryLoading, BeneficiarySuccess] when GetBeneficiariesEvent is added.',
      build: () {
        when(() => beneRepository.getBeneficiaries(1))
            .thenAnswer((_) async => right(beneficiaries));
        return beneficiaryBloc;
      },
      act: (bloc) => bloc.add(const GetBeneficiariesEvent(1)),
      expect: () => <BeneficiaryState>[
        BeneficiaryLoading(),
        BeneficiarySuccess(beneficiaries),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'emits [BeneficiaryLoading, BeneficiaryFailer] when GetBeneficiariesEvent is added with failur',
      build: () {
        when(() => beneRepository.getBeneficiaries(1))
            .thenAnswer((_) async => left(Failure()));
        return beneficiaryBloc;
      },
      act: (bloc) => bloc.add(const GetBeneficiariesEvent(1)),
      expect: () => <BeneficiaryState>[
        BeneficiaryLoading(),
        const BeneficiaryFailer('An unexpected error occurred'),
      ],
    );
  });

  group('onAddBeneficiariesEvent', () {
    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'emits [BeneficiaryLoading, BeneficiarySuccess] when GetBeneficiariesEvent is added.',
      build: () {
        beneficiaries.add(beneficiaryToBeAdded);
        when(() => beneRepository.postNewBeneficiary(1, 'New Guy'))
            .thenAnswer((_) async => right(beneficiaries));
        return beneficiaryBloc;
      },
      act: (bloc) =>
          bloc.add(AddBeneficiariesEvent(AddBeneficiaryParam('New Guy', 1))),
      expect: () => <BeneficiaryState>[
        BeneficiaryLoading(),
        BeneficiarySuccess(beneficiaries),
      ],
    );

    blocTest<BeneficiaryBloc, BeneficiaryState>(
      'emits [BeneficiaryLoading, BeneficiaryFailer] when GetBeneficiariesEvent is added with failur',
      build: () {
        beneficiaries.add(beneficiaryToBeAdded);
        when(() => beneRepository.postNewBeneficiary(1, 'New Guy'))
            .thenAnswer((_) async => left(Failure()));
        return beneficiaryBloc;
      },
      act: (bloc) =>
          bloc.add(AddBeneficiariesEvent(AddBeneficiaryParam('New Guy', 1))),
      expect: () => <BeneficiaryState>[
        BeneficiaryLoading(),
        const BeneficiaryFailer('An unexpected error occurred'),
      ],
    );
  });
}

List<Beneficiary> beneficiaries = [
  const Beneficiary(
      beneficiaryId: 900, nickName: 'Mr. Test', mobile: '+96158678', balance: 0)
];

var beneficiaryToBeAdded = const Beneficiary(
    beneficiaryId: 901, nickName: 'New Guy', mobile: '+96158777', balance: 0);
