// part of 'init_dependencies.dart';
// final serviceLocator = GetIt.instance;

// Future<void> initDependencies() async {
//   _initAuth();
//   _initBlog();
//   final supaBase = await Supabase.initialize(
//     url: AppSecrets.supabaseUrl,
//     anonKey: AppSecrets.supabaseAnnonKey,
//   );
//   //hive initialization
//   Hive.init((await getApplicationDocumentsDirectory()).path);

//   serviceLocator.registerLazySingleton(() => supaBase.client);
//   //hive
//   serviceLocator.registerLazySingleton(() => Hive.box('blogs'));
//   //core
//   serviceLocator.registerLazySingleton(
//     () => AppUserCubit(),
//   );
//   //to check internet connection
//   serviceLocator.registerFactory<ConnectionChecker>(
//     () => ConnectionCheckerImpl(
//       serviceLocator(),
//     ),
//   );

//   //
//   serviceLocator.registerFactory(
//     () => ConnectionCheckerImpl(
//       serviceLocator(),
//     ),
//   );
// }

// void _initAuth() {
//   //initialize the instance once and reuse it many times
//   //Data source
//   serviceLocator
//     ..registerFactory<AuthRemoteDataSource>(
//       () => AuthRemoteDataSourceImpl(
//         serviceLocator(),
//       ),
//     )
//     //Repository
//     ..registerFactory<AuthRepository>(
//       () => AuthRepositoryImpl(
//         serviceLocator(),
//         serviceLocator(),
//       ),
//     )
//     //--------------------------------------------------
//     //Usercases
//     ..registerFactory(
//       () => UserSignUp(
//         serviceLocator(),
//       ),
//     )

//     // for login
//     ..registerFactory(
//       () => UserLogin(
//         serviceLocator(),
//       ),
//     )
//     //current user
//     ..registerFactory(
//       () => CurrentUser(
//         serviceLocator(),
//       ),
//     )
//     //--------------------------------------------------
//     //instancing bloc only once
//     //bloc
//     ..registerLazySingleton(
//       () => AuthBloc(
//         userSignUp: serviceLocator(),
//         userLogin: serviceLocator(),
//         currentUser: serviceLocator(),
//         appUserCubit: serviceLocator(),
//       ),
//     );
// }

// // for blog------------------------------
// void _initBlog() {
//   //Data source
//   serviceLocator
//     ..registerFactory<BlogRemoteDataSource>(
//       () => BlogRemoteDataSourceImpl(
//         serviceLocator(),
//       ),
//     )
//     //for local data source
//     ..registerFactory<BlogLocalDataSource>(
//       () => BlogLocalDataSourceImpl(
//         serviceLocator(),
//       ),
//     )
//     //repository
//     ..registerFactory<BlogRepository>(
//       () => BlogRepositoryImpl(
//         serviceLocator(),
//         serviceLocator(),
//         serviceLocator(),
//       ),
//     )
// //usercases
//     ..registerFactory(
//       () => UploadBlog(
//         serviceLocator(),
//       ),
//     )
//     ..registerFactory(() => GetAllBlogs(serviceLocator()))
//     //bloc
//     ..registerLazySingleton(
//       () => BlogBloc(
//         uploadBlog: serviceLocator(),
//         getAllBlogs: serviceLocator(),
//       ),
//     );
// }

part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey,
  );

  final appDocumentsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDir.path);

  serviceLocator.registerLazySingleton(() => supabase.client);
  final blogBox = await Hive.openBox('blogs');
  serviceLocator.registerLazySingleton(() => blogBox);
  // serviceLocator.registerLazySingleton(
  //   () =>
  //    Hive.box('blogs'),
  //   // Hive.openBox('blogs'),
  // );

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
