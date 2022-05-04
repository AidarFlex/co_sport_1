import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/models/events.dart';
import 'package:co_sport_map/models/message.dart';
import 'package:co_sport_map/services/chatroom_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/view/chats/chat_schedule.dart';
import 'package:co_sport_map/view/explore_events/event_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

class EventConversation extends StatefulWidget {
  final Events data;
  const EventConversation({Key? key, required this.data}) : super(key: key);
  @override
  _EventConversationState createState() => _EventConversationState();
}

class _EventConversationState extends State<EventConversation> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  int limit = 20;
  addMessage() {
    if (messageEditingController.text.trim().isNotEmpty) {
      ChatroomService().sendNewMessageEvent(
          DateTime.now(),
          Constants.prefs!.getString('userId') as String,
          messageEditingController.text.trim(),
          Constants.prefs!.getString('name') as String,
          widget.data.eventId);
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
                  // custom message
                  if (data.type != "") {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 8.0),
                      child: Card(
                        child: Center(
                          child: ListTile(
                            leading: const Icon(
                              FeatherIcons.info,
                              size: 20,
                            ),
                            title: Text(
                              data.message!,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return MessageTile(
                    message: data.message!,
                    sendByMe:
                        Constants.prefs!.getString('userId') == data.sentby,
                    sentByName: data.sentByName!,
                    dateTime: data.dateTime!,
                  );
                })
            : const Center(
                child: Text("Начать общение"),
              );
      },
    );
  }

  @override
  void initState() {
    ChatroomService()
        .getEventMessages(widget.data.eventId!, limit)
        .then((value) {
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
            .getEventMessages(widget.data.eventId!, limit)
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
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EventInfo(
                    eventId: widget.data.eventId!,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Text(
                    widget.data.eventName!,
                    style: TextStyle(color: Theme.of(context).backgroundColor),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
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
                    chatRoomId: widget.data.eventId!,
                    usersNames: widget.data.playersId!,
                    users: widget.data.playersId!,
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
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
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
