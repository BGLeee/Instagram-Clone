import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import '../../../../../const.dart';
import '../../../cubit/post/cubit/post_cubit.dart';
import '../../Post/widget/like_animation_widget.dart';

class PostCardWidget extends StatefulWidget {
  final PostEntity post;
  const PostCardWidget({super.key, required this.post});

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  bool _isLikeAnimating = false;
  String? _currentUserUid;

  @override
  void initState() {
    super.initState();
    ic.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUserUid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        child:
                            profileWidget(imageUrl: widget.post.userProfileUrl),
                      )),
                  sizeHor(10),
                  Text(
                    "${widget.post.username}",
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  _openBottomModalSheet(context);
                },
                child: const Icon(
                  Icons.more_vert,
                  color: primaryColor,
                ),
              )
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
                child: profileWidget(imageUrl: widget.post.postImageUrl),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
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
                      color: widget.post.likes!.contains(_currentUserUid)
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
                      widget.post.likes!.contains(_currentUserUid)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: widget.post.likes!.contains(_currentUserUid)
                          ? Colors.red
                          : primaryColor,
                    ),
                  ),
                  sizeHor(10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageConst.commentPage);
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
            "${widget.post.totalLikes} likes",
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold),
          ),
          sizeVer(10),
          Row(
            children: [
              Text(
                "${widget.post.username}",
                style: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold),
              ),
              sizeHor(10),
              Text(
                "${widget.post.description}",
                style: const TextStyle(color: primaryColor),
              ),
            ],
          ),
          sizeVer(10),
          Text(
            "View all ${widget.post.totalcomments} comments",
            style: const TextStyle(color: darkGreyColor),
          ),
          sizeVer(10),
          Text(
            DateFormat("dd/MMM/yyy").format(widget.post.createAt!.toDate()),
            style: const TextStyle(color: darkGreyColor),
          ),
        ],
      ),
    );
  }

  _openBottomModalSheet(BuildContext context) {
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
                              arguments: widget.post);
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
    BlocProvider.of<PostCubit>(context)
        .deletePost(post: PostEntity(postId: widget.post.postId));
    Navigator.pop(context);
  }

  _likePost() {
    // final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // final postCollection = firebaseFirestore.collection(FirebaseConst.posts);
    // postCollection.doc(widget.post.postId).update({
    //   "likes": FieldValue.arrayRemove(["slfjsljfls"]),
    //   "totalLikes": 1,
    // });

    BlocProvider.of<PostCubit>(context)
        .likePost(post: PostEntity(postId: widget.post.postId));
  }
}
