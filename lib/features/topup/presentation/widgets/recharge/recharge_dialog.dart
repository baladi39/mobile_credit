import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/dialog_header.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/recharge/cubit/recharge_cubit.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/recharge/recharge_form.dart';

class RechargeDialog extends StatelessWidget {
  final int beneficiaryId;
  final double balance;
  const RechargeDialog(this.beneficiaryId, this.balance, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RechargeCubit(),
      child: Dialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        shadowColor: Colors.black,
        insetPadding: const EdgeInsets.all(24.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title with close button
              const DialogHeader(title: 'Recharge Beneficiary'),
              // Form
              RechargeForm(beneficiaryId, balance)
            ],
          ),
        ),
      ),
    );
  }
}
