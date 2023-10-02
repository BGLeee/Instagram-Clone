import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/domain/usecases/storage/upload_profile_image_toStograge_usecase.dart';
import '../../../../const.dart';
import '../../cubit/user/cubit/user_cubit.dart';
import '../../widgets/profile_widget.dart';
import 'profile_form_widget.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfilePage({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _userNameController;
  TextEditingController? _websiteController;
  TextEditingController? _bioController;

  bool? _isUpdating = false;
  File? _image;

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
    _nameController = TextEditingController(text: widget.currentUser.name);
    _userNameController =
        TextEditingController(text: widget.currentUser.username);
    _websiteController =
        TextEditingController(text: widget.currentUser.website);
    _bioController = TextEditingController(text: widget.currentUser.bio);
  }

  @override
  void dispose() {
    _nameController!.dispose();
    _userNameController!.dispose();
    _websiteController!.dispose();
    _bioController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Edit Profile"),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.close,
              size: 32,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                _updateUserProfileWithImage();
              },
              child: const Icon(
                Icons.done,
                color: blueColor,
                size: 32,
              ),
            ),
          )
        ],
      ),
      body: _isUpdating == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: profileWidget(
                              imageUrl: widget.currentUser.profileUrl,
                              image: _image),
                        ),
                      ),
                    ),
                    sizeVer(15),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: const Text(
                          "Change profile photo",
                          style: TextStyle(
                              color: blueColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    sizeVer(15),
                    ProfileFormWidget(
                      title: "Name",
                      controller: _nameController,
                    ),
                    sizeVer(15),
                    ProfileFormWidget(
                      title: "Username",
                      controller: _userNameController,
                    ),
                    sizeVer(15),
                    ProfileFormWidget(
                      title: "Website",
                      controller: _websiteController,
                    ),
                    sizeVer(15),
                    ProfileFormWidget(
                      title: "Bio",
                      controller: _bioController,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _updateUserProfileWithImage() {
    if (_image == null) {
      _updateUserProfile("");
    } else {
      ic
          .sl<UploadImageToStorageUseCase>()
          .call(_image, false, "profileImages")
          .then((profileUrl) {
        _updateUserProfile(profileUrl);
      });
    }
  }

  _updateUserProfile(String? url) {
    setState(() {
      _isUpdating = true;
    });
    BlocProvider.of<UserCubit>(context)
        .updateUser(
          user: UserEntity(
              uid: widget.currentUser.uid,
              username: _userNameController!.text,
              name: _nameController!.text,
              bio: _bioController!.text,
              website: _websiteController!.text,
              profileUrl: url),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
    });
    Navigator.pop(context);
  }
}
