import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/models/message.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/chatroom_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/view/chats/chat_schedule.dart';
import 'package:co_sport_map/view/teams/team_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class TeamConversation extends StatefulWidget {
  final Teams data;
  const TeamConversation({required this.data, Key? key}) : super(key: key);
  @override
  _TeamConversationState createState() => _TeamConversationState();
}

class _TeamConversationState extends State<TeamConversation> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  int limit = 20;
  addMessage() {
    if (messageEditingController.text.trim().isNotEmpty) {
      ChatroomService().sendNewMessageTeam(
          DateTime.now(),
          Constants.prefs!.getString('userId') as String,
          messageEditingController.text.trim(),
          Constants.prefs!.getString('name') as String,
          widget.data.teamId);
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
    ChatroomService().getTeamMessages(widget.data.teamId!, limit).then((value) {
      setState(() {
        chats = value;
      });
    });
    super.initState();
    _controller.addListener(_scrollListener);
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
            .getTeamMessages(widget.data.teamId!, limit)
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
    String sportIcon = '';
    switch (widget.data.sport) {
      case "Volleyball":
        sportIcon = "assets/icons8-volleyball-96.png";
        break;
      case "Basketball":
        sportIcon = "assets/icons8-basketball-96.png";
        break;
      case "Cricket":
        sportIcon = "assets/icons8-cricket-96.png";
        break;
      case "Football":
        sportIcon = "assets/icons8-soccer-ball-96.png";
        break;
    }
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TeamInfo(
                    teamID: widget.data.teamId!,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                child: Image.asset(sportIcon),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(
                width: 8,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Text(widget.data.teamName!,
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: Theme.of(context).backgroundColor)),
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
                    chatRoomId: widget.data.teamId!,
                    usersNames: widget.data.player!,
                    users: widget.data.playerId!,
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
                            hintText: "Сообщение...",
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

class MessageTile extends StatefulWidget {
  final String message;
  final bool sendByMe;
  final String sentByName;
  final DateTime dateTime;

  const MessageTile({
    required this.message,
    required this.sendByMe,
    required this.sentByName,
    required this.dateTime,
    Key? key,
  }) : super(key: key);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  List colors = [
    Colors.yellow[200],
    Colors.grey[200],
  ];
  Random random = Random();

  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() => colorIndex = random.nextInt(2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sendByMe ? 48 : 0,
        right: widget.sendByMe ? 0 : 48,
      ),
      alignment: widget.sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: widget.sendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))
              : const BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
          color: widget.sendByMe
              ? const Color(0xff004E52).withOpacity(0.9)
              : Theme.of(context).primaryColor.withOpacity(0.9),
        ),
        child: widget.sendByMe
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      widget.message,
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
                      DateFormat().add_jm().format(widget.dateTime).toString(),
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sentByName,
                    style: TextStyle(
                      color: colors[colorIndex],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          DateFormat()
                              .add_jm()
                              .format(widget.dateTime)
                              .toString(),
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
                          widget.message,
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
                ],
              ),
      ),
    );
  }
}
