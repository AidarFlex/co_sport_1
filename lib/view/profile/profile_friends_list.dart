import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/services/user_services.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/view/profile/other_user_profile.dart';
import 'package:co_sport_map/widget/single_friend_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:provider/provider.dart';

class ProfileFriendsList extends StatefulWidget {
  const ProfileFriendsList({Key? key}) : super(key: key);

  @override
  _ProfileFriendsListState createState() => _ProfileFriendsListState();
}

class _ProfileFriendsListState extends State<ProfileFriendsList> {
  Stream? userFriend;
  TextEditingController friendsSearch = TextEditingController();
  String searchQuery = "";
  @override
  void initState() {
    super.initState();
    friendsSearch = TextEditingController();
    getUserFriends();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  getUserFriends() async {
    UserService().getFriends().then((snapshots) {
      setState(() {
        userFriend = snapshots;
      });
    });
  }

  Widget friends() {
    return StreamBuilder(
      stream: userFriend,
      builder: (context, AsyncSnapshot asyncSnapshot) {
        return asyncSnapshot.hasData
            ? asyncSnapshot.data.docs.length > 0
                ? ListView.builder(
                    itemCount: asyncSnapshot.data.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return SingleFriendCard(
                        imageLink:
                            asyncSnapshot.data.docs[index].get('profileImage'),
                        name: asyncSnapshot.data.docs[index].get('name'),
                        userId: asyncSnapshot.data.docs[index].get('friendId'),
                      );
                    })
                : Center(
                    child: Image.asset("assets/add-friends.png"),
                  )
            : const Loader();
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              showSearch(context: context, delegate: UserSearch());
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
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Поиск",
                    style: TextStyle(
                      color: Theme.of(context)
                          .inputDecorationTheme
                          .hintStyle
                          ?.color,
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
            children: [friends()],
          ),
        ),
      ],
    );
  }
}

class UserSearch extends SearchDelegate<ListView> {
  getUser(String query) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: query)
        .limit(1)
        .snapshots();
  }

  getUserFeed(String query) {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userSearchParam", arrayContains: query)
        .limit(5)
        .snapshots();
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
                                  asyncSnapshot.data.documents[index]
                                      .get('profileImage'),
                                ),
                              ),
                            ),
                            title: Text(
                              asyncSnapshot.data.documents[index].get('name'),
                            ),
                            subtitle: Text(
                              asyncSnapshot.data.documents[index]
                                  .get('username'),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtherUserProfile(
                                      userID: asyncSnapshot
                                          .data.documents[index]
                                          .get('userId'),
                                    )),
                          );
                        },
                        child: Card(
                          child: ListTile(
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
                              asyncSnapshot.data?.documents[index]
                                  .get('username'),
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
