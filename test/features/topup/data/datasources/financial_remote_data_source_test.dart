import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_credit/core/error/exceptions.dart';
import 'package:mobile_credit/fake_datebase.dart';
import 'package:mobile_credit/features/topup/data/datasources/financial_remote_data_source.dart';
import 'package:mobile_credit/features/topup/data/models/user_financial_summary_model.dart';

void main() {
  late FinancialRemoteDataSource financialRemoteDataSource;
  late FakeDatebase fakeDatebase;
  setUp(() {
    fakeDatebase = FakeDatebase();
    financialRemoteDataSource = FinancialRemoteDataSourceImpl(fakeDatebase);
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
      var result = await financialRemoteDataSource.postUserDebitPendTransData(
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
          financialRemoteDataSource.postUserDebitPendTransData(userId, amount);
      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });

    test(
        'Post a pending transaction. User balance is enought with transaction fee and api should return error of insufficient funds',
        () async {
      // Arrange
      var userId = 5; // insufficient funds user
      var amount = 100.00;
      // Act
      var result =
          financialRemoteDataSource.postUserDebitPendTransData(userId, amount);
      // Assert
      expect(result, throwsA(const TypeMatcher<ServerException>()));
    });

    test('Getting user financial summary negative scenario', () async {
      // Arrange
      var userId = 3;
      var amount = 100.00;
      // Act
      var result =
          financialRemoteDataSource.postUserDebitPendTransData(userId, amount);
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
      await financialRemoteDataSource.postUserDebitPendTransData(
          testUserId, amount);
      // Updating user monthly spending (there is  8 sec delay...)
      var result = await financialRemoteDataSource.postUserDebitTransData(
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
      await financialRemoteDataSource.postUserDebitPendTransData(
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
