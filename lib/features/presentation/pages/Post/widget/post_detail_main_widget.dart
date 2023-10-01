import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/post/get_signle_post/cubit/get_single_post_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Post/widget/like_animation_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class PostDetailMainWidget extends StatefulWidget {
  final String? postId;
  const PostDetailMainWidget({super.key, required this.postId});

  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {
  bool _isLikeAnimating = false;
  String? _currentUserUid;

  @override
  void initState() {
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.postId!);
    // context.read<GetSinglePostCubit>().getSinglePost(postId: widget.postId!);
    super.initState();
    ic.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUserUid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: const Text("Post Detail"),
        backgroundColor: backGroundColor,
      ),
      body: BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
          builder: (context, getSinglePostState) {
        if (getSinglePostState is GetSinglePostLoaded) {
          final singlePost = getSinglePostState.post;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            width: 30,
                            height: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: profileWidget(
                                  imageUrl: singlePost.userProfileUrl),
                            )),
                        sizeHor(10),
                        Text(
                          "${singlePost.username}",
                          style: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    singlePost.creatorUid == _currentUserUid
                        ? InkWell(
                            onTap: () {
                              _openBottomModalSheet(context, singlePost);
                            },
                            child: const Icon(
                              Icons.more_vert,
                              color: primaryColor,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                sizeVer(10),
                GestureDetector(
                  onDoubleTap: () {
                    _likePost();
                    setState(() {
                      _isLikeAnimating = true;
                    });
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: profileWidget(imageUrl: singlePost.postImageUrl),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isLikeAnimating ? 1 : 0,
                      child: LikeAnimationWidget(
                          duration: const Duration(milliseconds: 200),
                          isLikeAnimating: _isLikeAnimating,
                          onLikeFinish: () {
                            setState(() {
                              _isLikeAnimating = false;
                            });
                          },
                          child: Icon(
                            Icons.favorite,
                            size: 100,
                            color: singlePost.likes!.contains(_currentUserUid)
                                ? Colors.white
                                : Colors.red,
                          )),
                    )
                  ]),
                ),
                sizeVer(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _likePost();
                          },
                          child: Icon(
                            singlePost.likes!.contains(_currentUserUid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: singlePost.likes!.contains(_currentUserUid)
                                ? Colors.red
                                : primaryColor,
                          ),
                        ),
                        sizeHor(10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PageConst.commentPage,
                                arguments: AppEntity(
                                    uid: _currentUserUid,
                                    postId: singlePost.postId));
                          },
                          child: const Icon(
                            FeatherIcons.messageCircle,
                            color: primaryColor,
                          ),
                        ),
                        sizeHor(10),
                        const Icon(
                          Icons.send,
                          color: primaryColor,
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.bookmark_border,
                      color: primaryColor,
                    )
                  ],
                ),
                sizeVer(10),
                Text(
                  "${singlePost.totalLikes} likes",
                  style: const TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
                sizeVer(10),
                Row(
                  children: [
                    Text(
                      "${singlePost.username}",
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    sizeHor(10),
                    Text(
                      "${singlePost.description}",
                      style: const TextStyle(color: primaryColor),
                    ),
                  ],
                ),
                sizeVer(10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.commentPage,
                        arguments: AppEntity(
                            postEntity: singlePost,
                            uid: _currentUserUid,
                            postId: singlePost.postId));
                  },
                  child: Text(
                    "View all ${singlePost.totalcomments} comments",
                    style: const TextStyle(color: darkGreyColor),
                  ),
                ),
                sizeVer(10),
                Text(
                  DateFormat("dd/MMM/yyy")
                      .format(singlePost.createAt!.toDate()),
                  style: const TextStyle(color: darkGreyColor),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  _openBottomModalSheet(BuildContext context, PostEntity postEntity) {
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
                        onTap: _deletePost,
                        child: const Text(
                          "Delete Post",
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.updatePostPage,
                              arguments: postEntity);
                        },
                        child: const Text(
                          "Update Post",
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
        });
  }

  _deletePost() {
    BlocProvider.of<PostCubit>(context).deletePost(
        post: PostEntity(
      postId: widget.postId,
    ));
    Navigator.pop(context);
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePost(post: PostEntity(postId: widget.postId));
  }
}
