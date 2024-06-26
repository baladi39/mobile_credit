import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/features/topup/data/datasources/financial_remote_data_source.dart';
import 'package:mobile_credit/features/topup/data/models/user_financial_summary_model.dart';

import '../../../../test_database.dart';

void main() {
  late FinancialRemoteDataSource financialRemoteDataSource;
  late TestDatebase testDatebase;
  setUp(() {
    testDatebase = TestDatebase();
    financialRemoteDataSource = FinancialRemoteDataSourceImpl(testDatebase);
  });
  group('GetCurrentFinacialData', () {
    test('Getting user financial summary positive scenario', () async {
      // Arrange
      var userFinSummary = const UserFinancialSummaryModel(
          totalBalance: 4000.20, totalMonthlySpent: 100);
      // Act
      var result =
          await financialRemoteDataSource.getCurrentFinancialData(testUserId);
      // Assert
      expect(result, userFinSummary);
    });

    test('Getting user financial summary negative scenario', () async {
      // Arrange
      var userId = 3;
      // Act
      var result = financialRemoteDataSource.getCurrentFinancialData(userId);
      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('PostUserDebitPendTransData', () {
    test(
        'Post a pending transaction positive scenario. User balance should be debited only with transaction fee',
        () async {
      // Arrange
      var userFinSummaryPend = const UserFinancialSummaryModel(
          totalBalance: 3899.20, totalMonthlySpent: 100);
      var amount = 100.00;
      // Act
      var result = await financialRemoteDataSource.postUserDebitPreTransData(
          testUserId, amount);
      // Assert
      expect(result, userFinSummaryPend);
    });

    test(
        'Post a pending transaction. User balance is 0 and api should return error of insufficient funds',
        () async {
      // Arrange
      var userId = 4; // zero balance user
      var amount = 100.00;
      // Act
      var result =
          financialRemoteDataSource.postUserDebitPreTransData(userId, amount);
      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });

    test(
        'Post a pending transaction. User balance is note enough with transaction fee and api should return error of insufficient funds',
        () async {
      // Arrange
      var userId = 5; // insufficient funds user
      var amount = 100.00;
      // Act
      var result =
          financialRemoteDataSource.postUserDebitPreTransData(userId, amount);
      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });
    test(
        'Post a pending transaction. User balance monthly spending will be reached with pending transaction should return error of monthly limit reached',
        () async {
      // Arrange
      var userId = 6; // about to reach their monthly limit
      var amount = 100.00;
      // Act
      var result =
          financialRemoteDataSource.postUserDebitPreTransData(userId, amount);
      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });

    test('Getting user financial summary negative scenario', () async {
      // Arrange
      var userId = 3;
      var amount = 100.00;
      // Act
      var result =
          financialRemoteDataSource.postUserDebitPreTransData(userId, amount);
      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('PostUserDebitTransData', () {
    test(
        'Post a pending transaction positive scenario. User balance should be debited only with transaction fee',
        () async {
      // Arrange
      var userFinSummarySuccess = const UserFinancialSummaryModel(
          totalBalance: 3899.20, totalMonthlySpent: 200);
      var amount = 100.00;
      // Act
      // Debiting user balance
      await financialRemoteDataSource.postUserDebitPreTransData(
          testUserId, amount);
      // Updating user monthly spending (there is  8 sec delay...)
      var result = await financialRemoteDataSource.postUserDebitPostTransData(
          testUserId, amount);
      // Assert
      expect(result, userFinSummarySuccess);
    });
  });

  group('PostUserRevertDebitTransData', () {
    test(
        'Post a pending transaction positive scenario. User balance should be debited only with transaction fee',
        () async {
      // Arrange
      var userFinSummarySuccess = const UserFinancialSummaryModel(
          totalBalance: 4000.20, totalMonthlySpent: 100);
      var amount = 100.00;
      // Act
      // Debiting user balance
      await financialRemoteDataSource.postUserDebitPreTransData(
          testUserId, amount);
      // Updating/Revert user balance (there is  2 sec delay...)
      var result = await financialRemoteDataSource.postUserRevertDebitTransData(
          testUserId, amount);
      // Assert
      expect(result, userFinSummarySuccess);
    });
  });
}

var testUserId = 1;
