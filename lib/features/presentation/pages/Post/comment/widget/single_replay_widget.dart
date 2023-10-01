import 'package:flutter/material.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/domain/usecases/user/get_current_uid_usecase.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class SingleReplayWidget extends StatefulWidget {
  final ReplayEntity replayEntity;
  final VoidCallback? onLongPress;
  final VoidCallback? onLikePressListener;
  const SingleReplayWidget(
      {super.key,
      required this.replayEntity,
      this.onLongPress,
      this.onLikePressListener});

  @override
  State<SingleReplayWidget> createState() => _SingleReplayWidgetState();
}

class _SingleReplayWidgetState extends State<SingleReplayWidget> {
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
      onLongPress: widget.replayEntity.creatorUid == _currentUserUid
          ? widget.onLongPress
          : () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                    profileWidget(imageUrl: widget.replayEntity.userProfileUrl),
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
                          "${widget.replayEntity.username}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        GestureDetector(
                          onTap: widget.onLikePressListener,
                          child: Icon(
                            widget.replayEntity.likes!.contains(_currentUserUid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            size: 20,
                            color: widget.replayEntity.likes!
                                    .contains(_currentUserUid)
                                ? Colors.red
                                : darkGreyColor,
                          ),
                        )
                      ],
                    ),
                    sizeVer(4),
                    Text(
                      "${widget.replayEntity.description}",
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizeVer(4),
                    Row(
                      children: [
                        Text(
                          DateFormat("dd/MMM/yyy")
                              .format(widget.replayEntity.createAt!.toDate()),
                          style: const TextStyle(
                              color: darkGreyColor, fontSize: 12),
                        ),
                        sizeHor(15),
                        GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   _isUserReplaying = !_isUserReplaying;
                              // });
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
