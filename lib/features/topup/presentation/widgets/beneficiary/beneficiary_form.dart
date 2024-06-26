import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/core/utils/extensions/screen_extensions.dart';
import 'package:mobile_credit/features/topup/domain/usecases/beneficiary/add_beneficiary.dart';

import 'bloc/beneficiary_bloc.dart';

class BeneficiaryForm extends StatefulWidget {
  const BeneficiaryForm({
    super.key,
  });

  @override
  State<BeneficiaryForm> createState() => _BeneficiaryFormState();
}

class _BeneficiaryFormState extends State<BeneficiaryForm> {
  late AppUserLoggedIn appUserLoggedIn;

  @override
  void initState() {
    appUserLoggedIn = context.read<AppUserCubit>().state as AppUserLoggedIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final beneficiaryFormKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(top: context.height * 24.h),
      child: Form(
        key: beneficiaryFormKey,
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller,
              decoration: const InputDecoration(label: Text('Nickname')),
              onChanged: (value) {},
              keyboardType: TextInputType.emailAddress,
              validator: (text) {
                if (text!.isEmpty) {
                  return 'Please enter a nickname';
                }
                if (text.length < 2) {
                  return 'Nickname too short';
                }
                if (text.length > 20) {
                  return 'Nickname too long';
                }
                return null;
              },
            ),
            SizedBox(height: context.height * 36.h),
            ElevatedButton(
              onPressed: () {
                log(appUserLoggedIn.user.id.toString());
                if (beneficiaryFormKey.currentState!.validate()) {
                  context.read<BeneficiaryBloc>().add(
                        AddBeneficiariesEvent(
                          AddBeneficiaryParam(
                            controller.text,
                            appUserLoggedIn.user.id,
                          ),
                        ),
                      );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
