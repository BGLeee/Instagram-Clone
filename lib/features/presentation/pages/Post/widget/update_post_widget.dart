import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/domain/usecases/storage/upload_profile_image_toStograge_usecase.dart';
import 'package:instagram_clone/features/presentation/cubit/post/cubit/post_cubit.dart';

import '../../../../../const.dart';
import '../../../widgets/profile_widget.dart';
import '../../Profile/profile_form_widget.dart';

class UpdatePostWidget extends StatefulWidget {
  final PostEntity post;
  const UpdatePostWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<UpdatePostWidget> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostWidget> {
  TextEditingController? _descriptionController;
  File? _image;
  bool _isUpdating = false;
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
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.post.description);
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Edit Post"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: _updatePost,
              child: const Icon(
                Icons.done,
                color: blueColor,
                size: 28,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: profileWidget(imageUrl: widget.post.userProfileUrl),
                ),
              ),
              sizeVer(10),
              Text(
                "${widget.post.username}",
                style: const TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              sizeVer(10),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: profileWidget(
                        imageUrl: widget.post.postImageUrl, image: _image),
                  ),
                  Positioned(
                      right: 10,
                      child: GestureDetector(
                        onTap: selectImage,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: blueColor,
                            size: 20,
                          ),
                        ),
                      ))
                ],
              ),
              sizeVer(10),
              ProfileFormWidget(
                title: "Description",
                controller: _descriptionController,
              ),
              sizeVer(10),
              _isUpdating == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Updating...",
                            style: TextStyle(color: Colors.white)),
                        sizeHor(10),
                        const CircularProgressIndicator()
                      ],
                    )
                  : const SizedBox(width: 0, height: 0)
            ],
          ),
        ),
      ),
    );
  }

  _updatePost() {
    setState(() {
      _isUpdating = true;
    });
    if (_image == null) {
      _submitUpdatePost(image: widget.post.postImageUrl!);
    } else {
      ic.sl<UploadImageToStorageUseCase>().call(_image!, true, "posts").then(
        (imageUrl) {
          _submitUpdatePost(image: imageUrl);
        },
      );
    }
  }

  _submitUpdatePost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .updatePost(
          post: PostEntity(
              creatorUid: widget.post.creatorUid,
              postId: widget.post.postId,
              postImageUrl: image,
              description: _descriptionController!.text),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
      _image = null;
      _descriptionController!.clear();
      Navigator.pop(context);
    });
  }
}
