import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';
import 'package:mobile_credit/locator_services.dart';

import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/views/login_view.dart';

void main() async {
  await locatorServices();
  runApp(multiBlocProvider);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile TopUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}

var multiBlocProvider = MultiBlocProvider(providers: [
  BlocProvider(
    create: (_) => serviceLocator<AppUserCubit>(),
  ),
  BlocProvider(
    create: (_) => serviceLocator<AuthBloc>(),
  ),
  BlocProvider(
    create: (_) => serviceLocator<BalanceBloc>(),
  ),
], child: const MyApp());
