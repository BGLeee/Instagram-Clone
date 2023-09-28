import 'package:flutter/material.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import '../../const.dart';
import '../../features/presentation/pages/Post/comment_page.dart';
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
      case PageConst.updatePostPage:
        {
          return routeBuilder(const UpdatePostPage());
        }
      case PageConst.commentPage:
        {
          return routeBuilder(const CommentPage());
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
