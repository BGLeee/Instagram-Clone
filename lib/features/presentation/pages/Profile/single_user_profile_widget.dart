import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_other_user/cubit/get_single_other_user_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/features/presentation/widgets/button_container_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import '../../../../const.dart';
import '../../cubit/auth/cubit/auth_cubit.dart';

class SingleUserProfileWidget extends StatefulWidget {
  final String? otherUserId;

  const SingleUserProfileWidget({Key? key, required this.otherUserId})
      : super(key: key);

  @override
  State<SingleUserProfileWidget> createState() => _SingleUserProfilePageState();
}

class _SingleUserProfilePageState extends State<SingleUserProfileWidget> {
  String? _currentUserUid;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetSingleOtherUserCubit>(context)
        .getSingleOtherUser(otherUid: widget.otherUserId!);
    BlocProvider.of<PostCubit>(context).getPosts(post: const PostEntity());
    ic.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUserUid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleOtherUserCubit, GetSingleOtherUserState>(
        builder: (context, getSingleOtherUserState) {
      if (getSingleOtherUserState is GetSingleOtherUserLoaded) {
        final singleUser = getSingleOtherUserState.otherUser;
        return Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            backgroundColor: backGroundColor,
            title: Text(
              "${singleUser.username}",
              style: const TextStyle(color: primaryColor),
            ),
            actions: [
              singleUser.uid != _currentUserUid
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        onTap: () {
                          _openBottomModalSheet(
                              context: context, currentUser: singleUser);
                        },
                        child: const Icon(
                          Icons.menu,
                          color: primaryColor,
                        ),
                      ),
                    )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: profileWidget(imageUrl: singleUser.profileUrl),
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "${singleUser.totalPosts}",
                                style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              sizeVer(8),
                              const Text(
                                "Posts",
                                style: TextStyle(color: primaryColor),
                              )
                            ],
                          ),
                          sizeHor(25),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageConst.followersPage,
                                  arguments: singleUser);
                            },
                            child: Column(
                              children: [
                                Text(
                                  "${singleUser.totalFollowers}",
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                sizeVer(8),
                                const Text(
                                  "Followers",
                                  style: TextStyle(color: primaryColor),
                                )
                              ],
                            ),
                          ),
                          sizeHor(25),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageConst.followingPage,
                                  arguments: singleUser);
                            },
                            child: Column(
                              children: [
                                Text(
                                  "${singleUser.totalFollowing}",
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                sizeVer(8),
                                const Text(
                                  "Following",
                                  style: TextStyle(color: primaryColor),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  sizeVer(10),
                  Text(
                    "${singleUser.name}",
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizeVer(10),
                  Text(
                    "${singleUser.bio}",
                    style: const TextStyle(color: primaryColor),
                  ),
                  sizeVer(10),
                  singleUser.uid == _currentUserUid
                      ? SizedBox()
                      : ButtonContainerWidget(
                          text: singleUser.followers!.contains(_currentUserUid)
                              ? "UnFollow"
                              : "Follow",
                          color: singleUser.followers!.contains(_currentUserUid)
                              ? secondaryColor
                              : Colors.blue,
                          onTapListener: () {
                            BlocProvider.of<UserCubit>(context)
                                .followUnFollowerUser(
                                    user: UserEntity(
                                        uid: _currentUserUid,
                                        otherUid: widget.otherUserId));
                          },
                        ),
                  const SizedBox(
                    child: Divider(color: Colors.white),
                  ),
                  BlocBuilder<PostCubit, PostState>(
                    builder: (context, postState) {
                      if (postState is PostLoaded) {
                        final posts = postState.posts
                            .where(
                                (post) => post.creatorUid == widget.otherUserId)
                            .toList();
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
                                      imageUrl: posts[index].postImageUrl),
                                ),
                              );
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }

  _openBottomModalSheet(
      {required BuildContext context, required UserEntity currentUser}) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "More Options",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: primaryColor),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    thickness: 1,
                    color: secondaryColor,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageConst.editProfilePage,
                            arguments: currentUser);
                      },
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: primaryColor),
                      ),
                    ),
                  ),
                  sizeVer(7),
                  const Divider(
                    thickness: 1,
                    color: secondaryColor,
                  ),
                  sizeVer(7),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<AuthCubit>(context).loggedOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, PageConst.signInPage, (route) => false);
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: primaryColor),
                      ),
                    ),
                  ),
                  sizeVer(7),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
