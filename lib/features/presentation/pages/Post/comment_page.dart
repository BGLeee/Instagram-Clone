import 'package:flutter/material.dart';
import '../../../../const.dart';
import '../../widgets/form_container_widget.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);
  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool _isUserReplaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Comments"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: secondaryColor, shape: BoxShape.circle),
                    ),
                    sizeHor(10),
                    const Text(
                      "Username",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                  ],
                ),
                sizeVer(10),
                const Text(
                  "This is very beautiful place",
                  style: TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
          sizeVer(10),
          const Divider(
            color: secondaryColor,
          ),
          sizeVer(10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: secondaryColor, shape: BoxShape.circle),
                  ),
                  sizeHor(10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Username",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                              Icon(
                                Icons.favorite_outline,
                                size: 20,
                                color: darkGreyColor,
                              )
                            ],
                          ),
                          sizeVer(4),
                          const Text(
                            "This is comment",
                            style: TextStyle(color: primaryColor),
                          ),
                          sizeVer(4),
                          Row(
                            children: [
                              const Text(
                                "08/07/2022",
                                style: TextStyle(
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
                                    style: TextStyle(
                                        color: darkGreyColor, fontSize: 12),
                                  )),
                              sizeHor(15),
                              const Text(
                                "View Replays",
                                style: TextStyle(
                                    color: darkGreyColor, fontSize: 12),
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
          ),
          _commentSection()
        ],
      ),
    );
  }

  _commentSection() {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(20)),
            ),
            sizeHor(10),
            Expanded(
                child: TextFormField(
              style: const TextStyle(color: primaryColor),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Post your comment...",
                  hintStyle: TextStyle(color: secondaryColor)),
            )),
            const Text(
              "Post",
              style: TextStyle(fontSize: 15, color: blueColor),
            )
          ],
        ),
      ),
    );
  }
}
