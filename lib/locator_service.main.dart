part of 'locator_services.dart';

final serviceLocator = GetIt.instance;

Future<void> locatorServices() async {
  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  // Very very fake database
  serviceLocator.registerLazySingleton(
    () => FakeDatebase(),
  );

  _initAuth();
  _initFinancial();
  _initBeneficiary();
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
      () => FinancialRemoteDataSourceImpl(
        serviceLocator(),
      ),
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
    );
}

void _initBeneficiary() {
  // Datasource
  serviceLocator
    ..registerFactory<BeneficiaryRemoteDataSource>(
      () => BeneficiaryRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<BeneficiaryRepository>(
      () => BeneficiaryRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => LatestBeneficiaries(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AddBeneficiary(
        serviceLocator(),
      ),
    );
}
