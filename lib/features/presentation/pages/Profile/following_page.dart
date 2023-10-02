import 'package:flutter/material.dart';
import 'package:instagram_clone/const.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/Injection_container.dart' as ic;
import 'package:instagram_clone/features/domain/usecases/user/get_user_usercases.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';

class FollowingPage extends StatelessWidget {
  final UserEntity currentUser;
  const FollowingPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: const Text("Following"),
        backgroundColor: backGroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Column(
          children: [
            Expanded(
                child: currentUser.following!.isEmpty
                    ? _noFollowingWidget()
                    : ListView.builder(
                        itemCount: currentUser.following!.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<List<UserEntity>>(
                            stream: ic
                                .sl<GetUserUseCase>()
                                .call(currentUser.following![index]),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasData == false) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.data!.isEmpty) {
                                return const SizedBox();
                              }
                              final singleUserData = snapshot.data!.first;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, PageConst.singleUserProfilePage,
                                      arguments: singleUserData.uid);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: profileWidget(
                                            imageUrl:
                                                singleUserData.profileUrl),
                                      ),
                                    ),
                                    sizeHor(10),
                                    Text(
                                      "${singleUserData.username}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ))
          ],
        ),
      ),
    );
  }

  _noFollowingWidget() {
    return const Center(
      child: Text(
        "No followings",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
