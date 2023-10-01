import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/domain/entities/replay/replay_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/replay/cubit/replay_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Profile/profile_form_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/button_container_widget.dart';

class EditReplayWidget extends StatefulWidget {
  final ReplayEntity? replay;
  const EditReplayWidget({super.key, this.replay});

  @override
  State<EditReplayWidget> createState() => _EditCommentPageState();
}

class _EditCommentPageState extends State<EditReplayWidget> {
  TextEditingController? _descriptionController;
  bool _isReplayUpdating = false;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.replay!.description);
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Edit Replay"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          ProfileFormWidget(
            title: "Replay",
            controller: _descriptionController,
          ),
          sizeVer(10),
          ButtonContainerWidget(
            color: Colors.blue,
            text: "Update replay",
            onTapListener: () {
              _editReplay();
            },
          ),
          sizeVer(10),
          _isReplayUpdating
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Updating...",
                      style: TextStyle(color: Colors.white)),
                  sizeHor(15),
                  const CircularProgressIndicator(),
                ])
              : Container(
                  width: 0,
                  height: 0,
                )
        ]),
      ),
    );
  }

  _editReplay() {
    setState(() {
      _isReplayUpdating = true;
    });
    BlocProvider.of<ReplayCubit>(context)
        .updateReplay(
            replay: ReplayEntity(
                postId: widget.replay!.postId,
                commentId: widget.replay!.commentId,
                replayId: widget.replay!.replayId,
                description: _descriptionController!.text))
        .then((value) {
      setState(() {
        _isReplayUpdating = false;
      });
      Navigator.pop(context);
    });
  }
}
