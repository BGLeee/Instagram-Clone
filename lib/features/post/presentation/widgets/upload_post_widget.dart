import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/post/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/user/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/storage/domain/usecases/storage/upload_profile_image_toStograge_usecase.dart';
import 'package:instagram_clone/features/post/presentation/cubit/post/get_posts/cubit/post_cubit.dart';
import 'package:instagram_clone/features/profile/presentation/widgets/profile_form_widget.dart';
import 'package:instagram_clone/features/profile/presentation/widgets/profile_widget.dart';
import 'package:uuid/uuid.dart';
import '../../../../../const.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class UploadPostWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostWidget({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<UploadPostWidget> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostWidget> {
  File? _image;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;
  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          toast("no image has been selected");
          log("no image has been selected");
        }
      });
    } catch (e) {
      toast("some shit happened while trying to pick image");
      log("$e");
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _image != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: backGroundColor,
              leading: GestureDetector(
                onTap: () {
                  setState(() {
                    _image = null;
                  });
                },
                child: const Icon(Icons.arrow_back_ios_new),
              ),
              actions: [
                GestureDetector(
                    onTap: _submitPost, child: const Icon(Icons.check))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: profileWidget(image: _image),
                  ),
                  sizeVer(20),
                  ProfileFormWidget(
                    title: "Description",
                    controller: _descriptionController,
                  ),
                  sizeVer(30),
                  _isUploading == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Uploading...",
                                style: TextStyle(color: Colors.white)),
                            sizeHor(10),
                            const CircularProgressIndicator()
                          ],
                        )
                      : const SizedBox(width: 0, height: 0)
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: backGroundColor,
            body: Center(
              child: GestureDetector(
                onTap: selectImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(.3),
                      shape: BoxShape.circle),
                  child: const Center(
                    child: Icon(
                      Icons.upload,
                      color: primaryColor,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ));
  }

  _submitPost() {
    setState(() {
      _isUploading = true;
    });
    ic
        .sl<UploadImageToStorageUseCase>()
        .call(_image, true, "posts")
        .then((photoUrl) => _postContentWithUrl(imageUrl: photoUrl));
  }

  _postContentWithUrl({required String imageUrl}) {
    BlocProvider.of<PostCubit>(context)
        .createPost(
            post: PostEntity(
                description: _descriptionController.text,
                createAt: Timestamp.now(),
                creatorUid: widget.currentUser.uid,
                likes: [],
                postId: const Uuid().v1(),
                postImageUrl: imageUrl,
                totalLikes: 0,
                totalcomments: 0,
                username: widget.currentUser.username,
                userProfileUrl: widget.currentUser.profileUrl))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUploading = false;
      _descriptionController.clear();
      _image = null;
    });
  }
}
