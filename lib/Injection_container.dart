import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'features/data/data_sources/remote_data_sources/remote_data_source.dart';
import 'features/data/data_sources/remote_data_sources/remote_data_source_impl.dart';
import 'features/data/repository/firebase_repository_impl.dart';
import 'features/domain/repository/firebase_repository.dart';
import 'features/domain/usecases/create_user_usecase.dart';
import 'features/domain/usecases/get_current_uid_usecase.dart';
import 'features/domain/usecases/get_user_usercases.dart';
import 'features/domain/usecases/get_users_usecases.dart';
import 'features/domain/usecases/is_sign_in_usecase.dart';
import 'features/domain/usecases/sign_in_usecase.dart';
import 'features/domain/usecases/sign_out_usecase.dart';
import 'features/domain/usecases/sign_up_usecase.dart';
import 'features/domain/usecases/update_user_usecase.dart';
import 'features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'features/presentation/cubit/user/cubit/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      signOutUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      getCurrentUidUseCase: sl.call(),
    ),
  );
  sl.registerFactory(
    () => CredentialCubit(
      signUpUseCase: sl.call(),
      signInUserUseCase: sl.call(),
    ),
  );

  sl.registerFactory(
    () => UserCubit(updateUserUseCase: sl.call(), getUsersUseCase: sl.call()),
  );
  // Use Cases
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => IsSignInUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => GetCurrentUidUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => SignUpUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => SignInUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => UpdateUserUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => GetUsersUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => CreateUserUseCase(repository: sl.call()));

  sl.registerLazySingleton(() => GetUserUseCase(repository: sl.call()));

  // Repository

  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source

  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseFirestore: sl.call(), firebaseAuth: sl.call()));

  // Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
}
