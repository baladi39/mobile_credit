import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_credit/core/common/widgets/loader.dart';
import 'package:mobile_credit/core/utils/show_snackbar.dart';
import 'package:mobile_credit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mobile_credit/features/topup/presentation/views/topup_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Login'),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                TopupView.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Simulate a login of a user',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AuthBloc>()
                        .add(const AuthLoginEvent(userId: 1)),
                    child: const Text('Verified User'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AuthBloc>()
                        .add(const AuthLoginEvent(userId: 2)),
                    child: const Text('Un-Verified User'),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
