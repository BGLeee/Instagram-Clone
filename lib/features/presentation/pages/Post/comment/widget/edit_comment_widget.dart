import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Profile/profile_form_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/button_container_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';

class EditCommentWidget extends StatefulWidget {
  final CommentEntity? comment;
  const EditCommentWidget({super.key, this.comment});

  @override
  State<EditCommentWidget> createState() => _EditCommentPageState();
}

class _EditCommentPageState extends State<EditCommentWidget> {
  TextEditingController? _descriptionController;
  bool _isCommentUpdating = false;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.comment!.description);
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
        title: const Text("Edit Comment"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          ProfileFormWidget(
            title: "comment",
            controller: _descriptionController,
          ),
          sizeVer(10),
          ButtonContainerWidget(
            color: Colors.blue,
            text: "Update comment",
            onTapListener: () {
              _editComment();
            },
          ),
          sizeVer(10),
          _isCommentUpdating
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

  _editComment() {
    log("Its in editComment");
    // BlocProvider.of<CommentCubit>(context).updateComment(
    //     comment: CommentEntity(
    //         postId: widget.comment!.postId,
    //         commentId: widget.comment!.commentId,
    //         description: "fjslfjsl"));
    setState(() {
      _isCommentUpdating = true;
    });
    FirebaseFirestore? firebaseFirestore = FirebaseFirestore.instance;
    final postCollection = firebaseFirestore
        .collection(FirebaseConst.posts)
        .doc(widget.comment!.postId)
        .collection(FirebaseConst.comment);
    Map<String, dynamic> commentInfo = Map();
    if (widget.comment!.description != "" &&
        widget.comment!.description != null) {
      commentInfo["description"] = _descriptionController!.text;
    }
    postCollection
        .doc(widget.comment!.commentId)
        .update(commentInfo)
        .then((value) {
      setState(() {
        _isCommentUpdating = false;
      });
      Navigator.pop(context);
    });
  }
}
