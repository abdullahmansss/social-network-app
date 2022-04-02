import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/cubit/cubit.dart';
import 'package:social_network/cubit/state.dart';

import 'constants.dart';
import 'messages.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: AppBloc.get(context).usersList.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) => BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      navigateTo(
                        context,
                        MessagesScreen(
                          userDataModel: AppBloc.get(context).usersList[index],
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            if (AppBloc.get(context)
                                .usersList[index]
                                .image
                                .isNotEmpty)
                              CircleAvatar(
                                radius: 20.0,
                                backgroundImage: NetworkImage(
                                  AppBloc.get(context).usersList[index].image,
                                ),
                              ),
                            if (AppBloc.get(context)
                                .usersList[index]
                                .image
                                .isEmpty)
                              CircleAvatar(
                                radius: 20.0,
                                child: Center(
                                  child: Text(
                                    AppBloc.get(context)
                                        .usersList[index]
                                        .username
                                        .characters
                                        .first,
                                    style: const TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            space10Horizontal(context),
                            Expanded(
                              child: Text(
                                AppBloc.get(context).usersList[index].username,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800,
                                ),
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
                    ),
                  );
                },
              ),
              separatorBuilder: (context, index) => space10Vertical(context),
              itemCount: AppBloc.get(context).usersList.length,
            )
          : const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
