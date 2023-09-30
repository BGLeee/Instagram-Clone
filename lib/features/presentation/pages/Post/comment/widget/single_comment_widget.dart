import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/features/presentation/widgets/form_container_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity? commentEntity;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikePressListener;
  const SingleCommentWidget(
      {super.key,
      required this.commentEntity,
      this.onLongPressListener,
      this.onLikePressListener});

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isUserReplaying = false;
  String _currentUserUid = "";
  @override
  void initState() {
    super.initState();
    ic.sl<GetCurrentUidUseCase>().call().then((uid) {
      setState(() {
        _currentUserUid = uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPressListener,
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
                    sizeVer(4),
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
                        const Text(
                          "View Replays",
                          style: TextStyle(color: darkGreyColor, fontSize: 12),
                        ),
                      ],
                    ),
                    _isUserReplaying == true ? sizeVer(10) : sizeVer(0),
                    _isUserReplaying == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const FormContainerWidget(
                                  hintText: "Post your replay..."),
                              sizeVer(10),
                              const Text(
                                "Post",
                                style: TextStyle(color: blueColor),
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
}
