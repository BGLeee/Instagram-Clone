import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/app_entity.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/post/get_signle_post/cubit/get_single_post_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/replay/cubit/replay_cubit.dart';
import 'package:instagram_clone/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Post/comment/widget/single_comment_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:uuid/uuid.dart';
import '../../../../../const.dart';
import '../../../widgets/form_container_widget.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;
  const CommentMainWidget({Key? key, required this.appEntity})
      : super(key: key);
  @override
  State<CommentMainWidget> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentMainWidget> {
  bool _isUserReplaying = false;
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid!);
    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId!);
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.appEntity.postId!);
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Comments"),
      ),
      body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
          builder: (context, singleUserState) {
        if (singleUserState is GetSingleUserLoaded) {
          final singleUser = singleUserState.user;
          return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
            builder: (context, singlePostState) {
              if (singlePostState is GetSinglePostLoaded) {
                final singlePost = singlePostState.post;
                return BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, commentState) {
                  if (commentState is CommentLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: profileWidget(
                                          imageUrl: singlePost.userProfileUrl),
                                    ),
                                  ),
                                  sizeHor(10),
                                  Text(
                                    "${singlePost.username}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                ],
                              ),
                              sizeVer(10),
                              Text(
                                "${singlePost.description}",
                                style: const TextStyle(color: primaryColor),
                              ),
                            ],
                          ),
                        ),
                        sizeVer(10),
                        const Divider(
                          color: secondaryColor,
                        ),
                        sizeVer(10),
                        Expanded(
                            child: ListView.builder(
                          itemCount: commentState.comment.length,
                          itemBuilder: (context, index) {
                            final singleComment = commentState.comment[index];
                            return BlocProvider.value(
                              value: ic.sl<ReplayCubit>(),
                              child: SingleCommentWidget(
                                currentUser: singleUser,
                                commentEntity: singleComment,
                                onLongPressListener: () {
                                  _openBottomModalSheet(
                                      context: context,
                                      comment: commentState.comment[index]);
                                },
                                onLikePressListener: () {
                                  _likeComment(
                                      comment: commentState.comment[index]);
                                }
                                // log("This is you liking the comment");
                                ,
                              ),
                            );
                          },
                        )),
                        _commentSection(currentUser: singleUser)
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: currentUser.profileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
                child: TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: primaryColor),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Post your comment...",
                  hintStyle: TextStyle(color: secondaryColor)),
            )),
            GestureDetector(
              onTap: () {
                // print("this is your value ${_descriptionController.text}");
                _createComment(currentUser);
              },
              child: const Text(
                "Post",
                style: TextStyle(fontSize: 15, color: blueColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    // log("this is your value ${_descriptionController.text}");
    BlocProvider.of<CommentCubit>(context)
        .createComment(
            comment: CommentEntity(
                commentId: const Uuid().v1(),
                createAt: Timestamp.now(),
                likes: [],
                username: currentUser.username,
                userProfileUrl: currentUser.profileUrl,
                description: _descriptionController.text,
                creatorUid: currentUser.uid,
                postId: widget.appEntity.postId,
                totalReplays: 0))
        .then((value) {
      _clear();
    });
  }

  _clear() {
    setState(() {
      _descriptionController.clear();
    });
  }

  _deleteComment({required String commentId, required String postId}) {
    BlocProvider.of<CommentCubit>(context)
        .deleteComment(
            comment: CommentEntity(commentId: commentId, postId: postId))
        .then((value) {
      Navigator.pop(context);
    });
  }

  _likeComment({required CommentEntity comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
        comment: CommentEntity(
            commentId: comment.commentId, postId: comment.postId));
  }

  _openBottomModalSheet(
      {required BuildContext context, required CommentEntity comment}) {
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
                        _deleteComment(
                          postId: comment.postId!,
                          commentId: comment.commentId!,
                        );
                      },
                      child: const Text(
                        "Delete Comment",
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
                        Navigator.pushNamed(
                            context, PageConst.updateCommentPage,
                            arguments: comment);
                      },
                      child: const Text(
                        "Update Comment",
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
