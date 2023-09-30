import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clone/features/domain/usecases/comment/create_comment_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/comment/like_comment_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/comment/read_comment_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/comment/update_comment_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/post/create_post_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/post/delete_post_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/post/like_post_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/post/read_post_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/post/read_single_post_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/replay/create_replay_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/replay/delete_replay_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/replay/like_post_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/replay/read_replay_usecase.dart';
import 'package:instagram_clone/features/domain/usecases/replay/update_replay_usecase.dart';
import 'package:instagram_clone/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/post/get_signle_post/cubit/get_single_post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/replay/cubit/replay_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';

import 'features/data/data_sources/remote_data_sources/remote_data_source.dart';
import 'features/data/data_sources/remote_data_sources/remote_data_source_impl.dart';
import 'features/data/repository/firebase_repository_impl.dart';
import 'features/domain/repository/firebase_repository.dart';
import 'features/domain/usecases/post/update_post_usecase.dart';
import 'features/domain/usecases/storage/upload_profile_image_toStograge_usecase.dart';
import 'features/domain/usecases/user/create_user_usecase.dart';
import 'features/domain/usecases/user/get_current_uid_usecase.dart';
import 'features/domain/usecases/user/get_user_usercases.dart';
import 'features/domain/usecases/user/get_users_usecases.dart';
import 'features/domain/usecases/user/is_sign_in_usecase.dart';
import 'features/domain/usecases/user/sign_in_usecase.dart';
import 'features/domain/usecases/user/sign_out_usecase.dart';
import 'features/domain/usecases/user/sign_up_usecase.dart';
import 'features/domain/usecases/user/update_user_usecase.dart';
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

  sl.registerFactory(() => GetSingleUserCubit(getSingleUserUseCase: sl.call()));
  sl.registerFactory(
      () => GetSinglePostCubit(readSinglePostUseCase: sl.call()));

  // Replay Cubit Injection
  sl.registerFactory(
    () => ReplayCubit(
        createReplayUseCase: sl.call(),
        deleteReplayUseCase: sl.call(),
        likeReplayUseCase: sl.call(),
        readReplaysUseCase: sl.call(),
        updateReplayUseCase: sl.call()),
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

  //Storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUseCase(repository: sl.call()));

  //post
  sl.registerLazySingleton(() => CreatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUseCase(repository: sl.call()));

  //comment
  sl.registerLazySingleton(() => CreateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUseCase(repository: sl.call()));

  //replay
  sl.registerLazySingleton(() => CreateReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplayUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadReplaysUseCase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplayUseCase(repository: sl.call()));

  // Repository

  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  // Remote Data Source

  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));

  // Post Cubit Injection
  sl.registerLazySingleton<PostCubit>(() => PostCubit(
      createPostUseCase: sl.call(),
      deletePostUseCase: sl.call(),
      likePostUseCase: sl.call(),
      readPostUseCase: sl.call(),
      updatePostUseCase: sl.call()));

  //Comment Cubit Injection
  sl.registerLazySingleton<CommentCubit>(() => CommentCubit(
      updateCommentUseCase: sl.call(),
      deleteCommentUseCase: sl.call(),
      likeCommentUseCase: sl.call(),
      readCommentUseCase: sl.call(),
      createCommentUseCase: sl.call()));

  // Externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
}
