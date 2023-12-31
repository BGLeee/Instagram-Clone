import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/home/presentation/pages/home/home_page.dart';
import 'package:instagram_clone/features/post/presentation/pages/Post/upload_post.dart';
import 'package:instagram_clone/features/search/presentation/pages/search_page.dart';
import 'package:instagram_clone/features/activity/presentation/pages/activity_page.dart';
import 'package:instagram_clone/features/profile/presentation/pages/profile_page.dart';
import 'package:instagram_clone/features/user/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';

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
                const HomePage(),
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
