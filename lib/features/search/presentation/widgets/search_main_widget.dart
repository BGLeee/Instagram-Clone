import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post/get_posts/cubit/post_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/widgets/profile_widget.dart';
import 'package:instagram_clone/features/search/presentation/widgets/search_widget.dart';
import 'package:instagram_clone/features/user/presentation/cubit/user/cubit/user_cubit.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({Key? key}) : super(key: key);
  @override
  State<SearchMainWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().getPosts(post: const PostEntity());
    context.read<UserCubit>().getUsers(user: const UserEntity());
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
          if (userState is UserLoaded) {
            final filterAllUser = userState.users
                .where((user) =>
                    user.username!.startsWith(_searchController.text) ||
                    user.username!
                        .toLowerCase()
                        .startsWith(_searchController.text.toLowerCase()) ||
                    user.username!.contains(_searchController.text) ||
                    user.username!
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                .toList();
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchWidget(
                    controller: _searchController,
                  ),
                  sizeVer(10),
                  _searchController.text.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: filterAllUser.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        PageConst.singleUserProfilePage,
                                        arguments: filterAllUser[index].uid);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: profileWidget(
                                              imageUrl: filterAllUser[index]
                                                  .profileUrl),
                                        ),
                                      ),
                                      sizeHor(10),
                                      Text(
                                        "${filterAllUser[index].username}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                );
                              }))
                      : Expanded(
                          child: BlocBuilder<PostCubit, PostState>(
                              builder: (context, postState) {
                            if (postState is PostLoaded) {
                              final posts = postState.posts;
                              return GridView.builder(
                                  itemCount: posts.length,
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, PageConst.postDetailPage,
                                            arguments: posts[index].postId);
                                      },
                                      child: SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: profileWidget(
                                            imageUrl:
                                                posts[index].postImageUrl),
                                      ),
                                    );
                                  });
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                        )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
