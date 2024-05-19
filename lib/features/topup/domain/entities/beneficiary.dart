import 'package:equatable/equatable.dart';

class Beneficiary extends Equatable {
  final int beneficiaryId;
  final String nickName;
  final String mobile;
  final double balance;
  final double monthlyDeposit;

  const Beneficiary({
    required this.beneficiaryId,
    required this.nickName,
    required this.mobile,
    required this.balance,
    this.monthlyDeposit = 0,
  });

  @override
  List<Object?> get props => [
        beneficiaryId,
        nickName,
        mobile,
        balance,
        monthlyDeposit,
      ];
}
