import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/features/topup/data/datasources/beneficiary_remote_data_source.dart';
import 'package:mobile_credit/features/topup/data/models/beneficiary_model.dart';

import '../../../../test_database.dart';

void main() {
  late BeneficiaryRemoteDataSource beneficiaryRemoteDataSource;

  late TestDatebase testDatabase;
  setUp(() {
    testDatabase = TestDatebase();
    beneficiaryRemoteDataSource = BeneficiaryRemoteDataSourceImpl(testDatabase);
  });

  group('GetBenficiaryData', () {
    test('Getting user list of beneficiary positive scenario', () async {
      // Arrange
      var userBeneficiaries = testBenficiaries;
      // Act
      var result =
          await beneficiaryRemoteDataSource.getBenficiaryData(testUserId);
      // Assert
      expect(result, userBeneficiaries);
    });

    test('Getting user list of beneficiary negative scenario', () async {
      // Arrange
      var userId = 3;
      // Act
      var result = beneficiaryRemoteDataSource.getBenficiaryData(userId);
      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('PostNewBenficiaryData', () {
    test('Adding new beneficiary positive scenario', () async {
      // Arrange
      var nickNameTest = 'Mr. Test';
      // Act
      var result = await beneficiaryRemoteDataSource.postNewBenficiaryData(
          testUserId, nickNameTest);
      // Assert
      // Phone number and beneficiary id is randomly generated
      // We can only check if the nickname is added
      expect(
        result.where((a) => a.nickName == nickNameTest).isNotEmpty,
        true,
      );
    });
  });

  group('PostBeneficiaryCredit', () {
    test('Posting beneficiary credit with 0 initial amount positive scenario',
        () async {
      // Arrange
      var beneficiaryId = 400;
      var amount = 100.0;
      var creditedBeneficiary = const BeneficiaryModel(
        beneficiaryId: 400,
        nickName: 'Daughter 1',
        mobile: '+97158555',
        balance: 100.0,
        monthlyDeposit: 100.0,
      );
      // Act
      await beneficiaryRemoteDataSource.postBeneficiaryCredit(
          testUserId, beneficiaryId, amount);

      // Getting what is saved in the testdatabase
      Map<String, dynamic> resultRaw = testDatabase.userBeneficiaries
          .where((a) => a['user_id'] == testUserId)
          .first['beneficiaries']
          .where((a) => a['beneficiary_id'] == beneficiaryId)
          .first;
      var result = BeneficiaryModel.fromJson(resultRaw);

      // Assert
      expect(result, creditedBeneficiary);
    });

    test(
        'Posting beneficiary credit with non-zero initial amount positive scenario',
        () async {
      // Arrange
      var beneficiaryId = 500;
      var amount = 100.0;
      var creditedBeneficiary = const BeneficiaryModel(
        beneficiaryId: 500,
        nickName: 'Daughter 2',
        mobile: '+97158556',
        balance: 113.0,
        monthlyDeposit: 100.0,
      );

      // Act
      await beneficiaryRemoteDataSource.postBeneficiaryCredit(
          testUserId, beneficiaryId, amount);

      // Getting what is saved in the testdatabase
      Map<String, dynamic> resultRaw = testDatabase.userBeneficiaries
          .where((a) => a['user_id'] == testUserId)
          .first['beneficiaries']
          .where((a) => a['beneficiary_id'] == beneficiaryId)
          .first;
      var result = BeneficiaryModel.fromJson(resultRaw);

      // Assert
      expect(result, creditedBeneficiary);
    });

    test(
        'Posting beneficiary credit with non-verfied user exciding 1000/month/beneficiary limit negative scenario',
        () async {
      // Arrange
      var beneficiaryId = 503;
      var amount = 100.0;
      var userId = 2;

      // Act
      var result = beneficiaryRemoteDataSource.postBeneficiaryCredit(
          userId, beneficiaryId, amount);

      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });

    test(
        'Posting beneficiary credit with verfied user exciding 500/month/beneficiary limit negative scenario',
        () async {
      // Arrange
      var beneficiaryId = 504;
      var amount = 100.0;
      var userId = 1;

      // Act
      var result = beneficiaryRemoteDataSource.postBeneficiaryCredit(
          userId, beneficiaryId, amount);

      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });
  });
}

var testUserId = 2;

var testBenficiaries = [
  const BeneficiaryModel(
    beneficiaryId: 400,
    nickName: 'Daughter 1',
    mobile: '+97158555',
    balance: 0,
    monthlyDeposit: 0,
  ),
  const BeneficiaryModel(
    beneficiaryId: 500,
    nickName: 'Daughter 2',
    mobile: '+97158556',
    balance: 13.0,
    monthlyDeposit: 0,
  ),
  const BeneficiaryModel(
      beneficiaryId: 503,
      nickName: 'Daughter 3',
      mobile: '+97158559',
      balance: 13.0,
      monthlyDeposit: 990.0)
];
