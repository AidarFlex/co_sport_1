import 'package:co_sport_map/models/message.dart';
import 'package:co_sport_map/services/chatroom_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/view/chats/chat_schedule.dart';
import 'package:co_sport_map/view/profile/other_user_profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  final List<dynamic> usersNames;
  final List<String> users;
  final List<dynamic> usersPics;
  const Conversation(
      {required this.chatRoomId,
      required this.usersNames,
      required this.users,
      required this.usersPics,
      Key? key})
      : super(key: key);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  Stream<DataSnapshot>? chats;
  TextEditingController messageEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  int limit = 20;
  addMessage() {
    if (messageEditingController.text.trim().isNotEmpty) {
      ChatroomService().sendNewMessage(
          DateTime.now(),
          Constants.prefs.getString('userId') as String,
          messageEditingController.text.trim(),
          Constants.prefs.getString('name') as String,
          widget.chatRoomId);
      setState(() {
        messageEditingController.text = "";
        _controller.jumpTo(_controller.position.minScrollExtent);
      });
    }
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot asyncSnapshot) {
        return asyncSnapshot.hasData
            ? ListView.builder(
                reverse: true,
                controller: _controller,
                itemCount: asyncSnapshot.data.docs.length,
                itemBuilder: (context, index) {
                  Message data =
                      Message.fromJson(asyncSnapshot.data.docs[index]);
                  return MessageTile(
                    message: data.message!,
                    sendByMe:
                        Constants.prefs.getString('userId') == data.sentby,
                    sentByName: data.sentByName!,
                    dateTime: data.dateTime!,
                  );
                })
            : const Center(
                child: Text("Начть общение"),
              );
      },
    );
  }

  @override
  void initState() {
    ChatroomService().getDirectMessages(widget.chatRoomId, limit).then((value) {
      setState(() {
        chats = value;
      });
    });
    _controller.addListener(_scrollListener);
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      _controller.jumpTo(_controller.position.minScrollExtent);
    });
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        limit += limit;
        ChatroomService()
            .getDirectMessages(widget.chatRoomId, limit)
            .then((value) {
          setState(() {
            chats = value;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int indexOfOtherUser = 0;
    if (Constants.prefs.getString('name') == widget.usersNames[0]) {
      indexOfOtherUser = 1;
    }
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUserProfile(
                  userID: widget.users[indexOfOtherUser],
                ),
              ),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  fit: BoxFit.fitWidth,
                  height: 32,
                  image: NetworkImage(
                    widget.usersPics[indexOfOtherUser],
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Text(
                  widget.usersNames[indexOfOtherUser],
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatSchedule(
                    chatRoomId: widget.chatRoomId,
                    usersNames: widget.usersNames,
                    users: widget.users,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.add_circle),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/chat background.png"),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: chatMessages(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLength: 256,
                        onTap: () {
                          _controller
                              .jumpTo(_controller.position.minScrollExtent);
                        },
                        controller: messageEditingController,
                        decoration: const InputDecoration(
                          counterText: "",
                          hintText: "Что то с чем то",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          addMessage();
                        },
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String sentByName;
  final DateTime dateTime;

  const MessageTile(
      {required this.message,
      required this.sendByMe,
      required this.sentByName,
      required this.dateTime,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: sendByMe ? 48 : 0,
        right: sendByMe ? 0 : 48,
      ),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))
              : const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
          color: sendByMe
              ? const Color(0xff004E52).withOpacity(0.9)
              : Theme.of(context).primaryColor.withOpacity(0.9),
        ),
        child: sendByMe
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      message,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      DateFormat().add_jm().format(dateTime).toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      DateFormat().add_jm().format(dateTime).toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      message,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
