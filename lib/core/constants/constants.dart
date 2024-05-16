class Constants {
  static List<int> topUpOptions = [5, 10, 20, 30, 50, 75, 100];
  static const generalErrorMessage = 'Something went wrong!';
  static const transactionFee = 1;

  /// Needs clarification
  /// Deposit amount limit for verified users is lower than unverified users
  ///
  /// Spending limit should be fetched dynamically on app launch, not hard-coded here
  static const monthlySpendLimit = 3000;
  static const beneficiarySpendLimitVerified = 500;
  static const beneficiarySpendLimitUnVerified = 1000;
}
