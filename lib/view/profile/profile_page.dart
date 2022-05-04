import 'dart:async';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:co_sport_map/utils/contansts.dart';
import 'package:co_sport_map/view/profile/drawer/drawer.dart';
import 'package:co_sport_map/view/profile/profile_friends_list.dart';
import 'package:co_sport_map/view/profile/schedule.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
  static _ProfileState of(BuildContext context) =>
      context.findAncestorStateOfType<_ProfileState>()!;
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  final db = FirebaseDatabase.instance;
  late StreamSubscription sub;
  Map data = <dynamic, dynamic>{};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    sub = db
        .ref('users/${Constants.prefs.getString('userId')}')
        .onValue
        .listen((DatabaseEvent snap) {
      setState(() {
        data = snap.snapshot.value as Map<dynamic, dynamic>;
        loading = true;
      });
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  void toggle() {
    animationController.isDismissed
        ? animationController.forward()
        : animationController.reverse();
  }

  static const double maxSlide = 300.0;

  @override
  Widget build(BuildContext context) {
    var myDrawer = Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[200]!.withOpacity(0.2),
                    width: 0.2,
                  ),
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    FeatherIcons.x,
                    color: Colors.white,
                  ),
                  onPressed: toggle,
                ),
              ),
            );
          },
        ),
      ),
      body: const DrawerBody(),
    );

    var _myDuration = const Duration(milliseconds: 300);
    var myChild = AnimatedContainer(
      curve: Curves.easeInOut,
      clipBehavior: Clip.antiAlias,
      duration: _myDuration,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: loading
                ? buildTitle(context, data["username"] ?? "Профиль")
                : null,
            centerTitle: true,
            elevation: 0,
            leading: Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[200]!.withOpacity(0.2),
                        width: 0.2,
                      ),
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        FeatherIcons.menu,
                      ),
                      onPressed: toggle,
                    ),
                  ),
                );
              },
            ),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(child: Text("Профиль")),
                Tab(child: Text("Друзья")),
                Tab(child: Text("График")),
              ],
              indicator: BubbleTabIndicator(
                indicatorHeight: 30.0,
                indicatorColor: Theme.of(context).primaryColor,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ),
          body: ProfileBody(data: data),
        ),
      ),
    );
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        double slide = maxSlide * animationController.value;
        double scale = 1;
        return Stack(
          children: [
            myDrawer,
            Transform(
              child: myChild,
              transform: Matrix4.identity()
                ..translate(slide)
                ..scale(scale),
              alignment: Alignment.centerLeft,
            ),
          ],
        );
      },
    );
  }
}

class ProfileBody extends StatefulWidget {
  final Map data;
  const ProfileBody({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    if (Profile.of(context).loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  MainUserProfile(data: widget.data),
                  const ProfileFriendsList(),
                  const Schedule(),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const Loader();
    }
  }
}

class MainUserProfile extends StatelessWidget {
  final Map data;
  const MainUserProfile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (data['profileImage'] != null)
            Container(
              width: 115,
              height: 115,
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(top: 8),
              child: FadeInImage(
                image: NetworkImage(data['profileImage']),
                fit: BoxFit.fitWidth,
                placeholder: const AssetImage("assets/ProfilePlaceholder.png"),
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0800d2ff),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              data['name'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 32.0,
              right: 32.0,
            ),
            child: Center(
              child: Text(
                data['bio'],
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //stats
          Column(
            children: <Widget>[
              Card(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            data['eventCount'].toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          const Text(
                            "Эвенты",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              data['friendCount'].toString(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            const Text(
                              "Друзья",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(
                          FeatherIcons.mail,
                          size: 24.0,
                        ),
                      ),
                    ),
                    Text(
                      data["emailId"],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (data['phoneNumber']['show'])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            FeatherIcons.phone,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Text(
                        data['phoneNumber']['ph'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                if (data["location"] != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(
                            FeatherIcons.mapPin,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          data["location"],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
