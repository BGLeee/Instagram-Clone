import 'package:flutter/material.dart';
import 'package:instagram_clone/features/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/presentation/pages/Post/comment/edit_comment_page.dart';
import 'package:instagram_clone/features/presentation/pages/Post/comment/widget/edit_replay_page.dart';
import 'package:instagram_clone/features/presentation/pages/Post/post_detail_page.dart';
import 'package:instagram_clone/features/presentation/pages/Profile/followers_page.dart';
import 'package:instagram_clone/features/presentation/pages/Profile/following_page.dart';
import 'package:instagram_clone/features/presentation/pages/Profile/single_user_profile.dart';
import '../../const.dart';
import '../../features/presentation/pages/Post/comment/comment_page.dart';
import '../../features/presentation/pages/Post/update_post_page.dart';
import '../../features/presentation/pages/Profile/edit_profile_page.dart';
import '../../features/presentation/pages/credentials/sign_in_page.dart';
import '../../features/presentation/pages/credentials/sign_up_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.editProfilePage:
        {
          if (args is UserEntity) {
            return routeBuilder(EditProfilePage(
              currentUser: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.followingPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowingPage(
              currentUser: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.followersPage:
        {
          if (args is UserEntity) {
            return routeBuilder(FollowersPage(
              currentUser: args,
            ));
          } else {
            return routeBuilder(const NoPageFound());
          }
        }
      case PageConst.updatePostPage:
        if (args is PostEntity) {
          return routeBuilder(UpdatePostPage(
            post: args,
          ));
        } else {
          return routeBuilder(const NoPageFound());
        }

      case PageConst.commentPage:
        if (args is AppEntity) {
          return routeBuilder(CommentPage(
            appEntity: args,
          ));
        } else {
          return routeBuilder(const NoPageFound());
        }
      case PageConst.postDetailPage:
        if (args is String) {
          return routeBuilder(PostDetailPage(
            postId: args,
          ));
        } else {
          return routeBuilder(const NoPageFound());
        }
      case PageConst.singleUserProfilePage:
        if (args is String) {
          return routeBuilder(SingleUserProfilePage(
            otherUserId: args,
          ));
        } else {
          return routeBuilder(const NoPageFound());
        }
      case PageConst.updateCommentPage:
        if (args is CommentEntity) {
          return routeBuilder(EditCommentPage(
            comment: args,
          ));
        } else {
          return routeBuilder(const NoPageFound());
        }
      case PageConst.updateReplayPage:
        if (args is ReplayEntity) {
          return routeBuilder(EditReplayPage(
            replay: args,
          ));
        } else {
          return routeBuilder(const NoPageFound());
        }
      case PageConst.signInPage:
        {
          return routeBuilder(const SignInPage());
        }
      case PageConst.signUpPage:
        {
          return routeBuilder(const SignUpPage());
        }
      default:
        {
          const NoPageFound();
        }
    }
    return null;
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page not found"),
      ),
      body: const Center(
        child: Text("Page not found"),
      ),
    );
  }
}
