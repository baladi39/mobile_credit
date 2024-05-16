import 'package:mobile_credit/features/topup/domain/entities/beneficiary.dart';

class BeneficiaryModel extends Beneficiary {
  BeneficiaryModel({
    required super.beneficiaryId,
    required super.nickName,
    required super.mobile,
    required super.amount,
  });

  // Methods for converting to and from JSON format, currently not used due to mocked responses.
  factory BeneficiaryModel.fromJson(Map<String, dynamic> map) {
    return BeneficiaryModel(
      beneficiaryId: map['beneficiaryId'] ?? '',
      nickName: map['nickName'] ?? '',
      mobile: map['mobile'] ?? '',
      amount: map['amount'] ?? '',
    );
  }

  Beneficiary copyWith({
    int? beneficiaryId,
    String? nickName,
    String? mobile,
    double? amount,
  }) {
    return Beneficiary(
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      nickName: nickName ?? this.nickName,
      mobile: mobile ?? this.mobile,
      amount: amount ?? this.amount,
    );
  }
}
