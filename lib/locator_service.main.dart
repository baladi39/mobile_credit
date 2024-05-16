part of 'locator_services.dart';

final serviceLocator = GetIt.instance;

Future<void> locatorServices() async {
  _initAuth();
  _initFinancial();

  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initFinancial() {
  // Datasource
  serviceLocator
    ..registerFactory<FinancialRemoteDataSource>(
      () => FinancialRemoteDataSourceImpl(),
    )
    // Repository
    ..registerFactory<FinancialRepository>(
      () => FinancialRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => LatestFinancialSummary(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => BalanceBloc(
        currentFinancialSummary: serviceLocator(),
      ),
    );
}
