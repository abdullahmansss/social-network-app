import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:social_network/cubit/cubit.dart';
import 'package:social_network/models/post_model.dart';

import 'constants.dart';
import 'cubit/state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'home.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isClicked = false;

  TextEditingController postTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Add new post',
            ),
            // actions: [
            //   IconButton(
            //       onPressed: () {},
            //       icon: Icon(
            //         Icons.check,
            //       ))
            // ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: postTextController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'post body must not be empty';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'What\'s in your mind?',
                      ),
                    ),
                  ),
                  if (AppBloc.get(context).postImage != null)
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      child: Image.file(
                        AppBloc.get(context).postImage!,
                        width: double.infinity,
                        height: 230.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            AppBloc.get(context).pickPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add,
                              ),
                              Text(
                                'Add photo',
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (AppBloc.get(context).postImage != null)
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              AppBloc.get(context).deletePostImage();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                Text(
                                  'delete photo',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Container(
                    height: 42.0,
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ),
                    ),
                    child: MaterialButton(
                      height: 42.0,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isClicked = true;
                          });

                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('kk:mm EEE d MMM').format(now);

                          if (AppBloc.get(context).postImage != null) {
                            firebase_storage.FirebaseStorage.instance
                                .ref(
                                    'uploads/${AppBloc.get(context).postImage!.path.split('/').last}')
                                .putFile(AppBloc.get(context).postImage!)
                                .then((p0) {
                              debugPrint(p0.state.name);

                              p0.ref.getDownloadURL().then((value) {
                                PostDataModel model = PostDataModel(
                                  image: value,
                                  likes: [],
                                  ownerImage: AppBloc.get(context).user!.image,
                                  ownerName: AppBloc.get(context).user!.username,
                                  shares: 0,
                                  text: postTextController.text,
                                  time: formattedDate,
                                  comments: [],
                                );

                                FirebaseFirestore.instance
                                    .collection('posts')
                                    .add(model.toJson())
                                    .then((value) {
                                  setState(() {
                                    isClicked = false;
                                  });

                                  navigateAndFinish(
                                    context,
                                    const HomeScreen(),
                                  );
                                }).catchError((error) {
                                  Fluttertoast.showToast(
                                    msg: error.toString(),
                                  );
                                });
                              }).catchError((error) {
                                Fluttertoast.showToast(
                                  msg: error.toString(),
                                );
                              });
                            })
                                .catchError((error) {
                              Fluttertoast.showToast(
                                msg: error.toString(),
                              );
                            });
                          } else {
                            PostDataModel model = PostDataModel(
                              comments: [],
                              image: '',
                              likes: [],
                              ownerImage: AppBloc.get(context).user!.image,
                              ownerName: AppBloc.get(context).user!.username,
                              shares: 0,
                              text: postTextController.text,
                              time: formattedDate,
                            );

                            FirebaseFirestore.instance
                                .collection('posts')
                                .add(model.toJson())
                                .then((value) {
                              setState(() {
                                isClicked = false;
                              });

                              navigateAndFinish(
                                context,
                                const HomeScreen(),
                              );
                            }).catchError((error) {
                              Fluttertoast.showToast(
                                msg: error.toString(),
                              );
                            });
                          }
                        }
                      },
                      child: isClicked
                          ? const CupertinoActivityIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Post',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
