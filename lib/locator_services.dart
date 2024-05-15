import 'package:get_it/get_it.dart';
import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecases/current_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

part 'locator_service.main.dart';
