import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/cubit/state.dart';
import 'package:social_network/models/chat_model.dart';
import 'package:social_network/models/message_model.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc() : super(Empty());

  static AppBloc get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  void bottomChanged(int index) {
    currentIndex = index;

    emit(BottomChanged());
  }

  File? postImage;

  var picker = ImagePicker();

  void pickPostImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      debugPrint(pickedFile.path);
      emit(PostImagePickedSuccess());
    } else {
      debugPrint('No image selected.');
      emit(PostImagePickedError());
    }
  }

  void deletePostImage() async {
    postImage = null;
    emit(PostImagePickedError());
  }

  UserDataModel? user;

  void getUserData(String id) {
    FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
      user = UserDataModel.fromJson(value.data()!);
      emit(GetUserSuccess());
    }).catchError((error) {
      debugPrint(error.toString());

      emit(GetUserError(
        message: error.toString(),
      ));
    });
  }

  List<Map<String, PostDataModel>> postsList = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').snapshots().listen((value) {
      postsList = [];

      for (var element in value.docs) {
        postsList.add(
            {element.reference.id: PostDataModel.fromJson(element.data())});
      }

      debugPrint(postsList.length.toString());

      emit(GetPostsSuccess());
    });
  }

  List<UserDataModel> usersList = [];

  void getUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((value) {
      usersList = [];

      for (var element in value.docs) {
        if (UserDataModel.fromJson(element.data()).uId != user!.uId) {
          usersList.add(UserDataModel.fromJson(element.data()));
        }
      }

      debugPrint(usersList.length.toString());

      emit(GetUsersSuccess());
    });
  }

  void updatePostLikes(Map<String, PostDataModel> post) {
    if (post.values.single.likes.any((element) => element == user!.uId)) {
      debugPrint('exist and remove');

      post.values.single.likes.removeWhere((element) => element == user!.uId);
    } else {
      debugPrint('not exist and add');

      post.values.single.likes.add(user!.uId);
    }

    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.keys.single)
        .update(post.values.single.toJson())
        .then((value) {
      emit(PostUpdatedSuccess());
    }).catchError((error) {
      debugPrint(error.toString());

      emit(PostUpdatedError(
        message: error.toString(),
      ));
    });
  }

  void updatePostShares(Map<String, PostDataModel> post) {
    post.values.single.shares++;

    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.keys.single)
        .update(post.values.single.toJson())
        .then((value) {
      emit(PostUpdatedSuccess());
    }).catchError((error) {
      debugPrint(error.toString());

      emit(PostUpdatedError(
        message: error.toString(),
      ));
    });
  }

  TextEditingController messageController = TextEditingController();

  void sendMessage(UserDataModel userDataModel) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uId)
        .collection('chats')
        .get()
        .then((value) {
      MessageDataModel model = MessageDataModel(
        time: DateTime.now().toString(),
        message: messageController.text,
        receiverId: userDataModel.uId,
        senderId: user!.uId,
      );

      if (value.docs
          .any((element) => element.reference.id != userDataModel.uId)) {
        ChatDataModel chatDataModel = ChatDataModel(
          username: userDataModel.username,
          userId: userDataModel.uId,
          userImage: userDataModel.image,
        );

        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uId)
            .collection('chats')
            .doc(userDataModel.uId)
            .set(chatDataModel.toJson())
            .then((value) {})
            .catchError((error) {
          debugPrint(error.toString());

          emit(CreateChatError(
            message: error.toString(),
          ));
        });

        FirebaseFirestore.instance
            .collection('users')
            .doc(userDataModel.uId)
            .collection('chats')
            .doc(user!.uId)
            .set(chatDataModel.toJson())
            .then((value) {})
            .catchError((error) {
          debugPrint(error.toString());

          emit(CreateChatError(
            message: error.toString(),
          ));
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uId)
            .collection('chats')
            .doc(userDataModel.uId)
            .collection('messages')
            .add(model.toJson())
            .then((value) {
          messageController.clear();
        }).catchError((error) {
          debugPrint(error.toString());

          emit(CreateChatError(
            message: error.toString(),
          ));
        });

        FirebaseFirestore.instance
            .collection('users')
            .doc(userDataModel.uId)
            .collection('chats')
            .doc(user!.uId)
            .collection('messages')
            .add(model.toJson())
            .then((value) {
          messageController.clear();
        }).catchError((error) {
          debugPrint(error.toString());

          emit(CreateChatError(
            message: error.toString(),
          ));
        });
      }
    }).catchError((error) {
      debugPrint(error.toString());

      emit(SendMessage(
        message: error.toString(),
      ));
    });
  }

  List<MessageDataModel> messagesList = [];

  void getMessages(UserDataModel userDataModel) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uId)
        .collection('chats')
        .doc(userDataModel.uId)
        .collection('messages').orderBy('time', descending: true,)
        .snapshots()
        .listen((value) {
      messagesList = [];

      for (var element in value.docs) {
        messagesList.add(MessageDataModel.fromJson(element.data()));
      }

      debugPrint(messagesList.length.toString());

      emit(GetMessagesSuccess());
    });
  }
}
