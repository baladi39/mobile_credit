part of 'beneficiary_bloc.dart';

sealed class BeneficiaryEvent extends Equatable {
  const BeneficiaryEvent();

  @override
  List<Object> get props => [];
}

final class GetBeneficiariesEvent extends BeneficiaryEvent {
  final int userId;
  const GetBeneficiariesEvent(this.userId);
}

final class AddBeneficiariesEvent extends BeneficiaryEvent {
  final AddBeneficiaryParam addBeneficiaryParam;
  const AddBeneficiariesEvent(this.addBeneficiaryParam);
}

final class CreditBeneficiariesEvent extends BeneficiaryEvent {
  final UserTopUpParam userTopUpParam;
  const CreditBeneficiariesEvent(this.userTopUpParam);
}
