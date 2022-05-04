import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:co_sport_map/models/events.dart';
import 'package:co_sport_map/models/teams.dart';
import 'package:co_sport_map/services/chatroom_services.dart';
import 'package:co_sport_map/services/team_services.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/view/chats/conversation.dart';
import 'package:co_sport_map/view/chats/event_conversation.dart';
import 'package:co_sport_map/view/chats/team_conversation.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:co_sport_map/widget/button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: buildTitle(context, "Сообщения"),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(child: Text("Друзья")),
              Tab(child: Text("Команды")),
              Tab(child: Text("Эвенты")),
            ],
            indicator: BubbleTabIndicator(
              indicatorHeight: 30.0,
              indicatorColor: Theme.of(context).primaryColor,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
        body: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: TabBarView(
                  children: [
                    DirectChats(),
                    TeamChats(),
                    EventChats(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventChats extends StatefulWidget {
  const EventChats({Key? key}) : super(key: key);

  @override
  _EventChatsState createState() => _EventChatsState();
}

class _EventChatsState extends State<EventChats> {
  Stream? userEventChats;
  @override
  void initState() {
    getEventChats();
    super.initState();
  }

  getEventChats() async {
    setState(() {
      FirebaseDatabase.instance
          .ref("events")
          .orderByChild('participants')
          .equalTo(Constants.prefs.get('userId'))
          .onValue;
    });
  }

  Widget getEventsFeed() {
    return StreamBuilder(
      stream: userEventChats,
      builder: (context, AsyncSnapshot event) {
        if (event.hasData) {
          if (event.data.snapshot.value != null) {
            return ListView.builder(
                itemCount: event.data.snapshot.value.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map map = event.data.snapshot.value;
                  Events data = Events.fromJson(map.values.elementAt(index));
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventConversation(
                                data: data,
                              ),
                            ));
                      },
                      title: Text(data.eventName!),
                      subtitle: Text(data.description!),
                    ),
                  );
                });
          } else {
            return Center(
              child: Image.asset("assets/team chat.png"),
            );
          }
        } else {
          return const Loader();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getEventsFeed());
  }
}

class TeamChats extends StatefulWidget {
  const TeamChats({Key? key}) : super(key: key);

  @override
  _TeamChatsState createState() => _TeamChatsState();
}

class _TeamChatsState extends State<TeamChats> {
  Stream? userTeamChats;
  @override
  void initState() {
    getTeamChats();
    super.initState();
  }

  getTeamChats() async {
    setState(() {
      userTeamChats = TeamService().getTeamsChatRoom();
    });
  }

  Widget getTeamsFeed() {
    return StreamBuilder(
      stream: userTeamChats,
      builder: (context, AsyncSnapshot event) {
        if (event.hasData) {
          if (event.data.snapshot.value != null) {
            return ListView.builder(
                itemCount: event.data.snapshot.value.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map map = event.data.snapshot.value;
                  Teams data = Teams.fromJson(map.values.elementAt(index));
                  String sportIcon = 'assets/icons8-volleyball-96.png';
                  switch (data.sport) {
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
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeamConversation(
                                data: data,
                              ),
                            ));
                      },
                      leading: Image.asset(sportIcon),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              data.teamName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          data.verified == 'Y'
                              ? const Icon(
                                  Icons.verified,
                                  size: 16.0,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child:
                      Image.asset("assets/teams_illustration.png", width: 300),
                ),
                Text(
                  "Вы не присоединился ни к какой команде, создайте ее",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Button(
                  myColor: Theme.of(context).primaryColor,
                  myText: "Создать команду",
                  onPressed: () {
                    Navigator.pushNamed(context, "/createteam");
                  },
                )
              ],
            );
          }
        } else {
          return const Loader();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getTeamsFeed(),
    );
  }
}

class DirectChats extends StatefulWidget {
  const DirectChats({Key? key}) : super(key: key);

  @override
  _DirectChatsState createState() => _DirectChatsState();
}

class _DirectChatsState extends State<DirectChats> {
  Stream? userDirectChats;
  TextEditingController friendsSearch = TextEditingController();
  String searchQuery = "";
  @override
  void initState() {
    // getUserChats();
    super.initState();
    friendsSearch = TextEditingController();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  // getUserChats() async {
  //   ChatroomService().getUsersDirectChats().then((snapshots) {
  //     setState(() {
  //       userDirectChats = snapshots;
  //     });
  //   });
  // }

  Widget getDirectChats() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
          .ref("DirectChats")
          .orderByChild('users')
          .equalTo(Constants.prefs.getString('userId'))
          .onValue,
      builder: (context, AsyncSnapshot event) {
        if (event.hasData) {
          if (event.data.snapshot.value != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: event.data.snapshot.value.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map map = event.data.snapshot.value;
                  int indexOfOtherUser = 0;
                  if (Constants.prefs.getString('name') ==
                      map.values.elementAt(index).get('usersNames')[0]) {
                    indexOfOtherUser = 1;
                  }
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () {
                          //Sending the user to the chat room
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Conversation(
                                  chatRoomId: map.values
                                      .elementAt(index)
                                      .get('chatRoomId'),
                                  usersNames: map.values
                                      .elementAt(index)
                                      .get('usersNames'),
                                  users:
                                      map.values.elementAt(index).get('users'),
                                  usersPics: map.values
                                      .elementAt(index)
                                      .get('usersPics')),
                            ),
                          );
                        },
                        title: Text(
                          map.values
                              .elementAt(index)
                              .get('usersNames')[indexOfOtherUser],
                          style: const TextStyle(fontSize: 18),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            width: 48,
                            height: 48,
                            image: NetworkImage(
                              map.values
                                  .elementAt(index)
                                  .get('usersPics')[indexOfOtherUser],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Image.asset("assets/chatting_illustration.png"),
              ),
            );
          }
        } else {
          return const Loader();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              showSearch(context: context, delegate: UserSearchDirect());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    FeatherIcons.search,
                    color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Поиск",
                    style: TextStyle(
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle!
                          .color,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [getDirectChats()],
          ),
        ),
      ],
    );
  }
}

class UserSearchDirect extends SearchDelegate<ListView> {
  getUser(String query) {
    return FirebaseDatabase.instance
        .ref("users/username")
        .equalTo(query)
        .limitToFirst(1)
        .onValue;
  }

  getUserFeed(String query) {
    return FirebaseDatabase.instance
        .ref("users/userSearchParam")
        .equalTo([query])
        .limitToFirst(5)
        .onValue;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context);
    return ThemeData(
      primaryColor: theme.currentTheme.appBarTheme.backgroundColor,
      appBarTheme: theme.currentTheme.appBarTheme,
      inputDecorationTheme: theme.currentTheme.inputDecorationTheme,
      textTheme: theme.currentTheme.textTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(FeatherIcons.x),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, ListView());
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
        stream: getUser(query),
        builder: (context, AsyncSnapshot asyncSnapshot) {
          return asyncSnapshot.hasData
              ? ListView.builder(
                  itemCount: asyncSnapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                image: NetworkImage(
                                  asyncSnapshot.data.docs[index]
                                      .get('profileImage'),
                                ),
                              ),
                            ),
                            title: Text(
                              asyncSnapshot.data.docs[index].get('name'),
                            ),
                            subtitle: Text(
                              asyncSnapshot.data.docs[index].get('username'),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: Image(
                    image: AssetImage("assets/search-illustration.png"),
                  ),
                );
        });
  }

  createChatRoom(String userId, BuildContext context, String username,
      String userProfile) {
    if (userId != Constants.prefs.getString('userId')) {
      List<String> users = [
        userId,
        Constants.prefs.getString('userId') as String
      ];
      String chatRoomId = getUsersInvolved(
          userId, Constants.prefs.getString('userId') as String);
      List<String> usersNames = [
        username,
        Constants.prefs.getString('name') as String
      ];
      List<String> usersPics = [
        userProfile,
        Constants.prefs.getString('profileImage') as String
      ];

      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId": chatRoomId,
        "usersNames": usersNames,
        "usersPics": usersPics,
      };
      ChatroomService().addChatRoom(chatRoom, chatRoomId);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Conversation(
                    chatRoomId: chatRoomId,
                    usersNames: usersNames,
                    users: users,
                    usersPics: usersPics,
                  )));
    }
  }

  getUsersInvolved(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b/_$a";
    } else {
      return "$a/_$b";
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: getUserFeed(query),
        builder: (context, AsyncSnapshot asyncSnapshot) {
          return asyncSnapshot.hasData
              ? ListView.builder(
                  itemCount: asyncSnapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          createChatRoom(
                              asyncSnapshot.data.documents[index].get('userId'),
                              context,
                              asyncSnapshot.data.documents[index].get('name'),
                              asyncSnapshot.data.documents[index]
                                  .get('profileImage'));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  image: NetworkImage(asyncSnapshot
                                      .data.documents[index]
                                      .get('profileImage')
                                      .toString()),
                                ),
                              ),
                              title: Text(asyncSnapshot.data.documents[index]
                                  .get('name')),
                              subtitle: Text(
                                asyncSnapshot.data.documents[index]
                                    .get('username'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: Image(
                    image: AssetImage("assets/search-illustration.png"),
                  ),
                );
        });
  }
}
