import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/services/tweet/post_services/post_firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MenuPost {
  // edit,
  delete,
}

class ProfilePostModel extends StatefulWidget {
  final String id;
  final String creator;
  final String userName;
  final String text;
  final DocumentSnapshot documentSnapshot;
  final Timestamp timestamp;

  const ProfilePostModel({
    super.key,
    required this.creator,
    required this.text,
    required this.documentSnapshot,
    required this.timestamp,
    required this.id,
    required this.userName,
  });

  @override
  State<ProfilePostModel> createState() => _ProfilePostModelState();
}

class _ProfilePostModelState extends State<ProfilePostModel> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userName = FirebaseAuth.instance.currentUser?.displayName;
    final PostService _postService = PostService();

    return Card(
        margin: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 10),
        child: Column(
          children: <Widget>[
            ListTile(
              // leading - User's Avata
              leading: Column(
                children: const [
                  Icon(
                    Icons.supervised_user_circle_outlined,
                    size: 50,
                  ),
                ],
              ),
              // title - User's Name take only 10 letters
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        // userName,
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Create a space
                    ],
                  ),
                  Column(
                    children: [
                      // const Padding(
                      //     padding: EdgeInsets.only(left: 150, right: 0)),
                      // Popup Menu Button
                      PopupMenuButton<MenuPost>(
                        onSelected: (value) async {
                          switch (value) {
                            case MenuPost.delete:
                              final shouldDelete =
                                  await showDeleteDialog(context);
                              if (shouldDelete) {
                                await _postService
                                    .deletePost(widget.documentSnapshot);
                              }
                            // case MenuPost.edit:
                          }
                        },
                        itemBuilder: (context) {
                          return const [
                            // Create a Poppup MenuItem
                            PopupMenuItem<MenuPost>(
                              value: MenuPost.delete,
                              child: Text('Delete'),
                            ),
                          ];
                        },
                      )
                    ],
                  ),
                ],
              ),
              // subtitle - User's post
              minVerticalPadding: 10,
              subtitle: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            // Display
            Row(children: <Widget>[
              const Padding(
                  padding: EdgeInsets.only(left: 80, top: 5, bottom: 5)),
              Flexible(
                  child: RichText(
                overflow: TextOverflow.ellipsis,
                strutStyle: const StrutStyle(fontSize: 12),
                text: TextSpan(
                    style: const TextStyle(color: Colors.black54),
                    text: widget.timestamp.toDate().toString()),
              )),
            ]),
            const SizedBox(height: 20)
          ],
        ));
  }
}

Future<bool> showDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete This Post'),
        content: const Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
final userId = FirebaseAuth.instance.currentUser?.uid;

Future<String> getUserName(userId) async {
  DocumentSnapshot snap = await usersCollection.doc(userId).get();
  String userName = await snap['@user_name'];
  return userName;
}