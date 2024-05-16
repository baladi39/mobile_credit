import 'package:get_it/get_it.dart';
import 'package:mobile_credit/features/topup/data/datasources/financial_remote_data_source.dart';
import 'package:mobile_credit/features/topup/domain/usecases/current_financial_summary.dart';
import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/current_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/topup/data/repositories/financial_repository_impl.dart';
import 'features/topup/domain/repository/financial_repository.dart';
import 'features/topup/presentation/widgets/balance/bloc/balance_bloc.dart';

part 'locator_service.main.dart';
