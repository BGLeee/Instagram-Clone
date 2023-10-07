import 'package:flutter/material.dart';
import 'package:instagram_clone/features/comment/presentation/pages/comment/comment_page.dart';
import 'package:instagram_clone/features/comment/presentation/pages/comment/edit_comment_page.dart';
import 'package:instagram_clone/features/credentials/presentation/pages/credentials/sign_in_page.dart';
import 'package:instagram_clone/features/credentials/presentation/pages/credentials/sign_up_page.dart';
import 'package:instagram_clone/features/home/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/comment/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/replay/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/post/presentation/pages/Post/post_detail_page.dart';
import 'package:instagram_clone/features/post/presentation/pages/Post/update_post_page.dart';
import 'package:instagram_clone/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:instagram_clone/features/profile/presentation/pages/followers_page.dart';
import 'package:instagram_clone/features/profile/presentation/pages/following_page.dart';
import 'package:instagram_clone/features/profile/presentation/pages/single_user_profile.dart';
import 'package:instagram_clone/features/replay/presentation/pages/edit_replay_page.dart';
import '../../const.dart';

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
