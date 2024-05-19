part of 'beneficiary_bloc.dart';

sealed class BeneficiaryState extends Equatable {
  const BeneficiaryState();

  @override
  List<Object> get props => [];
}

final class BeneficiaryInitial extends BeneficiaryState {}

final class BeneficiaryLoading extends BeneficiaryState {}

final class BeneficiarySuccess extends BeneficiaryState {
  final List<Beneficiary> beneficiaries;
  const BeneficiarySuccess(this.beneficiaries);
}

final class BeneficiaryFailer extends BeneficiaryState {
  final String message;
  const BeneficiaryFailer(this.message);
}

final class BeneficiaryCreditSuccess extends BeneficiaryState {
  final UserTopUpParam userTopUpParam;
  const BeneficiaryCreditSuccess(this.userTopUpParam);
}

final class BeneficiaryCreditFailer extends BeneficiaryState {
  final String message;
  final UserTopUpParam userTopUpParam;
  const BeneficiaryCreditFailer(this.message, this.userTopUpParam);
}
