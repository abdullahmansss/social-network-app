import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/constants.dart';
import 'package:social_network/cubit/cubit.dart';
import 'package:social_network/models/message_model.dart';
import 'package:social_network/models/user_model.dart';

import 'cubit/state.dart';

class MessagesScreen extends StatefulWidget {
  final UserDataModel userDataModel;

  const MessagesScreen({
    Key? key,
    required this.userDataModel,
  }) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();

    AppBloc.get(context).getMessages(widget.userDataModel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.userDataModel.username,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (AppBloc.get(context).messagesList.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (AppBloc.get(context).messagesList[index].senderId == AppBloc.get(context).user!.uId) {
                          return MyItem(
                            model: AppBloc.get(context).messagesList[index],
                          );
                        }

                        return UserItem(
                          model: AppBloc.get(context).messagesList[index],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          space10Vertical(context),
                      itemCount: AppBloc.get(context).messagesList.length,
                    ),
                  ),
                if (AppBloc.get(context).messagesList.isEmpty)
                  const Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                space20Vertical(context),
                TextFormField(
                  controller: AppBloc.get(context).messageController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'type message',
                    border: const OutlineInputBorder(),
                    suffixIcon: MaterialButton(
                      minWidth: 1,
                      onPressed: () {
                        AppBloc.get(context).sendMessage(widget.userDataModel);
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyItem extends StatelessWidget {
  final MessageDataModel model;

  const MyItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(
                  15.0,
                ),
                topEnd: Radius.circular(
                  15.0,
                ),
                bottomStart: Radius.circular(
                  15.0,
                ),
              ),
              color: Colors.teal,
            ),
            child: Text(
              model.message,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UserItem extends StatelessWidget {
  final MessageDataModel model;

  const UserItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(
                  15.0,
                ),
                topEnd: Radius.circular(
                  15.0,
                ),
                bottomEnd: Radius.circular(
                  15.0,
                ),
              ),
              color: Colors.grey[200],
            ),
            child: Text(
              model.message,
              style: const TextStyle(),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
