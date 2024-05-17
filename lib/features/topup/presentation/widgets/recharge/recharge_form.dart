import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mobile_credit/core/constants/constants.dart';
import 'package:mobile_credit/features/topup/domain/usecases/user_debit.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/recharge/cubit/recharge_cubit.dart';

class RechargeForm extends StatefulWidget {
  const RechargeForm({
    super.key,
  });

  @override
  State<RechargeForm> createState() => _RechargeFormState();
}

class _RechargeFormState extends State<RechargeForm> {
  late AppUserLoggedIn appUserLoggedIn;

  @override
  void initState() {
    appUserLoggedIn = context.read<AppUserCubit>().state as AppUserLoggedIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RechargeCubit, RechargeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              DropdownButton<int>(
                value: state.topUpOptionValue,
                onChanged: (value) {
                  context.read<RechargeCubit>().updateSelectedtopUpValue(
                      value ?? Constants.topUpOptions.first);
                },
                items: Constants.topUpOptions
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () {
                  context.read<BalanceBloc>().add(
                        UserDebitEvent(
                          UserTopUpParam(
                            appUserLoggedIn.user.id,
                            100,
                            state.topUpOptionValue.toDouble(),
                          ),
                        ),
                      );
                  log(appUserLoggedIn.user.id.toString());
                  log(state.topUpOptionValue.toString());
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              )
            ],
          ),
        );
      },
    );
  }
}
