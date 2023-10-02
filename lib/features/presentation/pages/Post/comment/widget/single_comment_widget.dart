import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/features/presentation/cubit/replay/cubit/replay_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Post/comment/widget/single_replay_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/form_container_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity? commentEntity;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikePressListener;
  final UserEntity? currentUser;
  const SingleCommentWidget(
      {super.key,
      this.currentUser,
      required this.commentEntity,
      this.onLongPressListener,
      this.onLikePressListener});

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isUserReplaying = false;
  String _currentUserUid = "";
  TextEditingController _replayDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReplayCubit>(context).getReplays(
        replay: ReplayEntity(
            postId: widget.commentEntity!.postId,
            commentId: widget.commentEntity!.commentId));

    ic.sl<GetCurrentUidUseCase>().call().then((uid) {
      setState(() {
        _currentUserUid = uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ReplayCubit>(context).getReplays(
        replay: ReplayEntity(
            postId: widget.commentEntity!.postId,
            commentId: widget.commentEntity!.commentId));
    return InkWell(
      onLongPress: widget.commentEntity!.creatorUid == _currentUserUid
          ? widget.onLongPressListener
          : () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(
                    imageUrl: widget.commentEntity!.userProfileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.commentEntity!.username}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        GestureDetector(
                          onTap: widget.onLikePressListener,
                          child: Icon(
                            widget.commentEntity!.likes!
                                    .contains(_currentUserUid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            size: 20,
                            color: widget.commentEntity!.likes!
                                    .contains(_currentUserUid)
                                ? Colors.red
                                : darkGreyColor,
                          ),
                        )
                      ],
                    ),
                    sizeVer(4),
                    Text(
                      "${widget.commentEntity!.description}",
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizeVer(8),
                    Row(
                      children: [
                        Text(
                          DateFormat("dd/MMM/yyy")
                              .format(widget.commentEntity!.createAt!.toDate()),
                          style: const TextStyle(
                              color: darkGreyColor, fontSize: 12),
                        ),
                        sizeHor(15),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _isUserReplaying = !_isUserReplaying;
                              });
                            },
                            child: const Text(
                              "Replay",
                              style:
                                  TextStyle(color: darkGreyColor, fontSize: 12),
                            )),
                        sizeHor(15),
                        GestureDetector(
                          onTap: () {
                            widget.commentEntity!.totalReplays == 0
                                ? toast("No Replays here")
                                : BlocProvider.of<ReplayCubit>(context)
                                    .getReplays(
                                        replay: ReplayEntity(
                                            postId:
                                                widget.commentEntity!.postId,
                                            commentId: widget
                                                .commentEntity!.commentId));
                          },
                          child: const Text(
                            "View Replays",
                            style:
                                TextStyle(color: darkGreyColor, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<ReplayCubit, ReplayState>(
                        builder: (context, replayState) {
                      if (replayState is ReplayLoaded) {
                        final replay = replayState.replays
                            .where((element) =>
                                element.commentId ==
                                widget.commentEntity!.commentId)
                            .toList();
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: replay.length,
                            itemBuilder: (context, index) {
                              return SingleReplayWidget(
                                replayEntity: replay[index],
                                onLongPress: () {
                                  _openBottomModalSheet(
                                      context: context, replay: replay[index]);
                                },
                                onLikePressListener: () {
                                  _likeReplay(replayEntity: replay[index]);
                                },
                              );
                            });
                      }
                      return SizedBox();
                    }),
                    _isUserReplaying == true ? sizeVer(10) : sizeVer(0),
                    _isUserReplaying == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FormContainerWidget(
                                  controller: _replayDescriptionController,
                                  hintText: "Post your replay..."),
                              sizeVer(10),
                              GestureDetector(
                                onTap: () {
                                  _createReplay();
                                },
                                child: const Text(
                                  "Post",
                                  style: TextStyle(color: blueColor),
                                ),
                              )
                            ],
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createReplay() async {
    if (_replayDescriptionController.text.isNotEmpty) {
      await BlocProvider.of<ReplayCubit>(context)
          .createReplay(
              replay: ReplayEntity(
                  replayId: const Uuid().v1(),
                  createAt: Timestamp.now(),
                  likes: [],
                  username: widget.currentUser!.username,
                  userProfileUrl: widget.currentUser!.profileUrl,
                  creatorUid: widget.currentUser!.uid,
                  postId: widget.commentEntity!.postId,
                  description: _replayDescriptionController.text,
                  commentId: widget.commentEntity!.commentId))
          .then((value) {
        setState(() {
          _replayDescriptionController.clear();
          _isUserReplaying = false;
        });
      });
    } else {
      toast("Enter a replay");
    }
  }

  _openBottomModalSheet(
      {required BuildContext context, required ReplayEntity replay}) {
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
                        _deleteReplay(replayEntity: replay);
                      },
                      child: const Text(
                        "Delete Replay",
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
                        Navigator.pushNamed(context, PageConst.updateReplayPage,
                            arguments: replay);
                      },
                      child: const Text(
                        "Update Replay",
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

  _deleteReplay({required ReplayEntity replayEntity}) {
    BlocProvider.of<ReplayCubit>(context)
        .deleteReplay(
            replay: ReplayEntity(
      postId: replayEntity.postId,
      commentId: replayEntity.commentId,
      replayId: replayEntity.replayId,
    ))
        .then((value) {
      Navigator.pop(context);
    });
  }

  _likeReplay({required ReplayEntity replayEntity}) {
    BlocProvider.of<ReplayCubit>(context).likeReplay(
        replay: ReplayEntity(
      postId: replayEntity.postId,
      commentId: replayEntity.commentId,
      replayId: replayEntity.replayId,
    ));
  }
}
