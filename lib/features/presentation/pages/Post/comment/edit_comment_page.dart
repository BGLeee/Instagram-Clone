import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/comment/cubit/comment_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/Post/comment/widget/edit_comment_widget.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class EditCommentPage extends StatefulWidget {
  final CommentEntity? comment;
  const EditCommentPage({super.key, this.comment});

  @override
  State<EditCommentPage> createState() => _EditCommentPageState();
}

class _EditCommentPageState extends State<EditCommentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ic.sl<CommentCubit>(),
      child: EditCommentWidget(comment: widget.comment),
    );
  }
}
