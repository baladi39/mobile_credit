class Beneficiary {
  final int beneficiaryId;
  final String nickName;
  final String mobile;
  final double balance;
  final double monthlyDeposit;

  Beneficiary({
    required this.beneficiaryId,
    required this.nickName,
    required this.mobile,
    required this.balance,
    this.monthlyDeposit = 0,
  });
}
