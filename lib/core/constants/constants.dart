class Constants {
  static const generalErrorMessage = 'Something went wrong!';

  /// Transaction fees and topupoptions should be fetched dynamically on app launch, not hard-coded here
  static List<int> topUpOptions = [5, 10, 20, 30, 50, 75, 100];
  static const transactionFee = 1;

  /// Needs clarification
  /// Deposit amount limit for verified users is lower than unverified users??
  /// I am following the User Story but we can change the limits here as needed
  ///
  /// Spending limit should be fetched dynamically on app launch, not hard-coded here
  static const monthlySpendLimit = 3000.0;
  static const beneficiarySpendLimitVerified = 500.0;
  static const beneficiarySpendLimitUnVerified = 1000.0;
}
