part of 'locator_services.dart';

final serviceLocator = GetIt.instance;

Future<void> locatorServices() async {
  _initAuth();

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

// void _initBlog() {
//   // Datasource
//   serviceLocator
//     ..registerFactory<BlogRemoteDataSource>(
//       () => BlogRemoteDataSourceImpl(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory<BlogLocalDataSource>(
//       () => BlogLocalDataSourceImpl(
//         serviceLocator(),
//       ),
//     )
//     // Repository
//     ..registerFactory<BlogRepository>(
//       () => BlogRepositoryImpl(
//         serviceLocator(),
//         serviceLocator(),
//         serviceLocator(),
//       ),
//     )
//     // Usecases
//     ..registerFactory(
//       () => UploadBlog(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(
//       () => GetAllBlogs(
//         serviceLocator(),
//       ),
//     )
//     // Bloc
//     ..registerLazySingleton(
//       () => BlogBloc(
//         uploadBlog: serviceLocator(),
//         getAllBlogs: serviceLocator(),
//       ),
//     );
// }
