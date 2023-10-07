import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clone/features/auth/data/data_sources/remote_data_sources/remote_data_source_auth.dart';
import 'package:instagram_clone/features/auth/data/data_sources/remote_data_sources/remote_data_source_auth_impl.dart';
import 'package:instagram_clone/features/auth/data/repository/firebase_repository_auth_impl.dart';
import 'package:instagram_clone/features/auth/domain/repository/firebase_repository_auth.dart';
import 'package:instagram_clone/features/auth/domain/usecases/user/is_sign_in_usecase.dart';
import 'package:instagram_clone/features/auth/domain/usecases/user/sign_out_usecase.dart';
import 'package:instagram_clone/features/auth/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:instagram_clone/features/comment/data/data_sources/remote_data_comment_source_impl.dart';
import 'package:instagram_clone/features/comment/data/data_sources/remote_data_comment_sources.dart';
import 'package:instagram_clone/features/comment/data/repository/firebase_comment_repository_impl.dart';
import 'package:instagram_clone/features/comment/domain/repository/firebase_comment_repository.dart';
import 'package:instagram_clone/features/comment/domain/usecases/comment/create_comment_usecase.dart';
import 'package:instagram_clone/features/comment/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:instagram_clone/features/comment/domain/usecases/comment/like_comment_usecase.dart';
import 'package:instagram_clone/features/comment/domain/usecases/comment/read_comment_usecase.dart';
import 'package:instagram_clone/features/comment/domain/usecases/comment/update_comment_usecase.dart';
import 'package:instagram_clone/features/comment/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:instagram_clone/features/credentials/data/data_sources/remote_data_sources/remote_data_source_credentials.dart';
import 'package:instagram_clone/features/credentials/data/data_sources/remote_data_sources/remote_data_source_credentials_impl.dart';
import 'package:instagram_clone/features/credentials/data/repository/firebase_repository_credentials_impl.dart';
import 'package:instagram_clone/features/credentials/domain/repository/firebase_repository_credentials.dart';
import 'package:instagram_clone/features/credentials/domain/usecases/sign_in_usecase.dart';
import 'package:instagram_clone/features/credentials/domain/usecases/sign_up_usecase.dart';
import 'package:instagram_clone/features/credentials/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:instagram_clone/features/post/data/data_sources/remote_data_sources/remote_data_post_source.dart';
import 'package:instagram_clone/features/post/data/data_sources/remote_data_sources/remote_data_post_source_impl.dart';
import 'package:instagram_clone/features/post/data/repository/firebase_post_repository_impl.dart';
import 'package:instagram_clone/features/post/domain/repository/firebase_post_repository.dart';
import 'package:instagram_clone/features/replay/data/data_source/remote_data_replay_source.dart';
import 'package:instagram_clone/features/replay/data/data_source/remote_data_replay_source_impl.dart';
import 'package:instagram_clone/features/replay/data/repository/firebase_replay_repository_impl.dart';
import 'package:instagram_clone/features/replay/domain/repository/firebase_replay_repository.dart';
import 'package:instagram_clone/features/replay/domain/usecases/replay/create_replay_usecase.dart';
import 'package:instagram_clone/features/replay/domain/usecases/replay/delete_replay_usecase.dart';
import 'package:instagram_clone/features/replay/domain/usecases/replay/like_post_usecase.dart';
import 'package:instagram_clone/features/replay/domain/usecases/replay/read_replay_usecase.dart';
import 'package:instagram_clone/features/replay/domain/usecases/replay/update_replay_usecase.dart';
import 'package:instagram_clone/features/storage/data/data_source/remote_data_source/remote_storage_data_source.dart';
import 'package:instagram_clone/features/storage/data/data_source/remote_data_source/remote_storage_data_source_impl.dart';
import 'package:instagram_clone/features/storage/data/repository/firebase_storage_repository_impl.dart';
import 'package:instagram_clone/features/storage/domain/repository/firebase_storage_repository.dart';
import 'package:instagram_clone/features/user/domain/usecases/user/follow_UnFollow_user_usecase.dart';
import 'package:instagram_clone/features/user/domain/usecases/user/get_single_other_user_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/post/create_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/post/delete_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/post/like_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/post/read_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/post/read_single_post_usecase.dart';
import 'package:instagram_clone/features/post/domain/usecases/post/update_post_usecase.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post/get_posts/cubit/post_cubit.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post/get_signle_post/cubit/get_single_post_cubit.dart';
import 'package:instagram_clone/features/replay/presentation/cubit/replay/cubit/replay_cubit.dart';
import 'package:instagram_clone/features/user/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:instagram_clone/features/user/presentation/cubit/user/get_single_other_user/cubit/get_single_other_user_cubit.dart';
import 'package:instagram_clone/features/user/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'features/user/data/data_sources/remote_data_sources/remote_data_source.dart';
import 'features/user/data/data_sources/remote_data_sources/remote_data_source_impl.dart';
import 'features/user/data/repository/firebase_repository_impl.dart';
import 'features/user/domain/repository/firebase_repository.dart';
import 'features/storage/domain/usecases/storage/upload_profile_image_toStograge_usecase.dart';
import 'features/user/domain/usecases/user/create_user_usecase.dart';
import 'features/user/domain/usecases/user/get_current_uid_usecase.dart';
import 'features/user/domain/usecases/user/get_user_usercases.dart';
import 'features/user/domain/usecases/user/get_users_usecases.dart';
import 'features/user/domain/usecases/user/update_user_usecase.dart';

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
    () => UserCubit(
        followUnFollowUserUseCase: sl.call(),
        updateUserUseCase: sl.call(),
        getUsersUseCase: sl.call()),
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

  sl.registerLazySingleton(
      () => GetSingleOtherUserUseCase(repository: sl.call()));

  sl.registerLazySingleton(
      () => FollowUnFollowUserUseCase(repository: sl.call()));

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

  // Auth Repository

  sl.registerLazySingleton<FirebaseRepositoryAuth>(
      () => FirebaseRepositoryAuthImpl(remoteDataSource: sl.call()));
  // Comment Repository
  sl.registerLazySingleton<FirebaseCommentRepository>(
      () => FirebaseCommentRepositoryImpl(remoteDataSource: sl.call()));
  // Credentials Repository
  sl.registerLazySingleton<FirebaseRepositoryCredentials>(
      () => FirebaseRepositoryCredentialsImpl(remoteDataSource: sl.call()));
  //Post Repository
  sl.registerLazySingleton<FirebasePostRepository>(() =>
      FirebasePostRepositoryImpl(firebaseRemotePostDataSource: sl.call()));
  // Replay Repository
  sl.registerLazySingleton<FirebaseReplayRepository>(
      () => FirebaseReplayRepositoryImpl(remoteDataSource: sl.call()));

  // Storage Repository
  sl.registerLazySingleton<FirebaseStorageRepository>(
      () => FirebaseStorageRepositoryImpl(remoteDataSource: sl.call()));
  //User Repository

  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  // Auth Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteDataAuthSource>(() =>
      FirebaseRemoteDataSourceAuthImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));
  //Comment Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteCommentDataSource>(() =>
      FirebaseRemoteCommentDataSourceImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));
  //Credentials Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteDataCredentialsSource>(() =>
      FirebaseRemoteDataSourceCredentialsImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));
  //Post Remote Data Source
  sl.registerLazySingleton<FirebaseRemotePostDataSource>(() =>
      FirebaseRemotePostDataSourceImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));
  //Replay Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteReplayDataSource>(() =>
      FirebaseRemoteReplayDataSourceImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));
  //Storage Remote Data Source
  sl.registerLazySingleton<FirebaseStorageRemoteDataSource>(() =>
      FirebaseStorageRemoteDataSourceImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));
  //User Remote Data Source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseFirestore: sl.call(),
          firebaseAuth: sl.call(),
          firebaseStorage: sl.call()));

  sl.registerLazySingleton<GetSingleOtherUserCubit>(
      () => GetSingleOtherUserCubit(getSingleOtherUserUseCase: sl.call()));

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
