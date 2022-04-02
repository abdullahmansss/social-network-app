import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_network/constants.dart';
import 'package:social_network/cubit/cubit.dart';

import 'add_post.dart';
import 'cubit/state.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: AppBloc.get(context).postsList.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) => BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              if(AppBloc.get(context)
                                  .postsList[index]
                                  .values
                                  .single
                                  .ownerImage.isNotEmpty)
                                CircleAvatar(
                                radius: 20.0,
                                backgroundImage: NetworkImage(
                                  AppBloc.get(context)
                                      .postsList[index]
                                      .values
                                      .single
                                      .ownerImage,
                                ),
                              ),
                              if(AppBloc.get(context)
                                  .postsList[index]
                                  .values
                                  .single
                                  .ownerImage.isEmpty)
                                CircleAvatar(
                                  radius: 20.0,
                                  child: Center(
                                    child: Text(
                                      AppBloc.get(context)
                                          .postsList[index]
                                          .values
                                          .single
                                          .ownerName.characters.first,
                                      style: const TextStyle(
                                        fontSize: 26.0,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              space10Horizontal(context),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppBloc.get(context)
                                          .postsList[index]
                                          .values
                                          .single
                                          .ownerName,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      AppBloc.get(context)
                                          .postsList[index]
                                          .values
                                          .single
                                          .time,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // IconButton(
                              //   padding: EdgeInsets.zero,
                              //   onPressed: () {},
                              //   icon: Icon(
                              //     Icons.more_vert,
                              //     size: 16.0,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const MyDivider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                AppBloc.get(context)
                                    .postsList[index]
                                    .values
                                    .single
                                    .text,
                              ),
                            ),
                            if (AppBloc.get(context)
                                .postsList[index]
                                .values
                                .single
                                .image
                                .isNotEmpty)
                              Image.network(
                                AppBloc.get(context)
                                    .postsList[index]
                                    .values
                                    .single
                                    .image,
                                width: double.infinity,
                                height: 220.0,
                                fit: BoxFit.cover,
                              ),
                            if (AppBloc.get(context)
                                .postsList[index]
                                .values
                                .single
                                .image
                                .isEmpty)
                              const MyDivider(),
                            space10Vertical(context),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${AppBloc.get(context).postsList[index].values.single.likes.length} likes',
                                  ),
                                  Spacer(),
                                  Text(
                                    '${AppBloc.get(context).postsList[index].values.single.comments.length} comments',
                                  ),
                                  Text(
                                    ' - ',
                                  ),
                                  Text(
                                    '${AppBloc.get(context).postsList[index].values.single.shares} shares',
                                  ),
                                ],
                              ),
                            ),
                            space10Vertical(context),
                            const MyDivider(),
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () {
                                      AppBloc.get(context).updatePostLikes(
                                          AppBloc.get(context)
                                              .postsList[index]);
                                    },
                                    child: Icon(
                                      AppBloc.get(context)
                                              .postsList[index]
                                              .values
                                              .single
                                              .likes
                                              .any((element) =>
                                                  element ==
                                                  AppBloc.get(context)
                                                      .user!
                                                      .uId)
                                          ? Icons.thumb_up
                                          : Icons.thumb_up_outlined,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: const Icon(
                                      FontAwesomeIcons.comment,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (AppBloc.get(context)
                                          .postsList[index]
                                          .values
                                          .single
                                          .image
                                          .isNotEmpty) {
                                        final img = await imageFromURL(
                                          'temp',
                                          AppBloc.get(context)
                                              .postsList[index]
                                              .values
                                              .single
                                              .image,
                                        );

                                        Share.shareFiles(
                                          [img!.path],
                                          text: AppBloc.get(context)
                                              .postsList[index]
                                              .values
                                              .single
                                              .text,
                                        ).whenComplete(() {
                                          AppBloc.get(context).updatePostShares(AppBloc.get(context).postsList[index]);
                                        });
                                      } else {
                                        Share.share(
                                          AppBloc.get(context)
                                              .postsList[index]
                                              .values
                                              .single
                                              .text,
                                        ).whenComplete(() {
                                          AppBloc.get(context).updatePostShares(AppBloc.get(context).postsList[index]);
                                        });
                                      }
                                    },
                                    child: const Icon(
                                      FontAwesomeIcons.share,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              separatorBuilder: (context, index) => space10Vertical(context),
              itemCount: AppBloc.get(context).postsList.length,
            )
          : const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          navigateTo(
            context,
            const AddPostScreen(),
          );
        },
        // label: const Text(
        //   'Post',
        // ),
      ),
    );
  }
}
