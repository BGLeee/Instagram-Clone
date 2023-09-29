import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Post/upload_post.dart';
import 'package:instagram_clone/features/presentation/pages/Profile/profile_page.dart';
import 'package:instagram_clone/features/presentation/pages/Search/search_page.dart';
import 'package:instagram_clone/features/presentation/pages/activity/activity_page.dart';
import 'package:instagram_clone/features/presentation/pages/home/home_page.dart';
import '../../../const.dart';
import '../cubit/user/cubit/user_cubit.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class MainScreen extends StatefulWidget {
  final String? uid;
  const MainScreen({Key? key, required this.uid}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.uid!);
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          return Scaffold(
            backgroundColor: backGroundColor,
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: backGroundColor,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home, color: primaryColor), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search, color: primaryColor), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle, color: primaryColor),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite, color: primaryColor), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined,
                        color: primaryColor),
                    label: ""),
              ],
              onTap: navigationTapped,
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                HomePage(),
                // BlocProvider.value(
                //   value: ic.sl<PostCubit>()..getPosts(post: PostEntity()),
                //   child: HomePage(),
                // ),
                // MultiBlocProvider(providers: [
                //   BlocProvider<PostCubit>(
                //       create: (context) =>
                //           ic.sl<PostCubit>()..getPosts(post: PostEntity()))
                // ], child: const HomePage()),
                const SearchPage(),
                UploadPostPage(
                  currentUser: currentUser,
                ),
                const ActivityPage(),
                ProfilePage(
                  currentUser: currentUser,
                )
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
