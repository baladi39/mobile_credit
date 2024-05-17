import 'package:flutter/material.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/dialog_header.dart';

import 'beneficiary_form.dart';

class AddBeneficiaryDialog extends StatefulWidget {
  const AddBeneficiaryDialog({super.key});

  @override
  State<AddBeneficiaryDialog> createState() => _AddBeneficiaryDialogState();
}

class _AddBeneficiaryDialogState extends State<AddBeneficiaryDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      shadowColor: Colors.black,
      insetPadding: const EdgeInsets.all(24.0),
      child: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with close button
            DialogHeader(title: 'Add Beneficiary'),
            // Form
            BeneficiaryForm()
          ],
        ),
      ),
    );
  }
}
