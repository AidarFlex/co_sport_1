import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co_sport_map/utils/theme_config.dart';
import 'package:co_sport_map/view/profile/other_user_profile.dart';
import 'package:co_sport_map/widget/build_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EventInfo extends StatefulWidget {
  final String eventId;
  const EventInfo({
    required this.eventId,
    Key? key,
  }) : super(key: key);
  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  StreamSubscription? sub;
  Map data = <String, dynamic>{};
  bool _loading = false;
  String? sportIcon;
  @override
  void initState() {
    super.initState();
    sub = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .snapshots()
        .listen((snap) {
      setState(() {
        data = snap.data()!;
        _loading = true;
      });
    });
  }

  @override
  void dispose() {
    sub!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (data['sportName']) {
      case "Volleyball":
        sportIcon = "assets/volleyball-image.jpg";
        break;
      case "Basketball":
        sportIcon = "assets/basketball-image.jpg";
        break;
      case "Cricket":
        sportIcon = "assets/cricket-image.jpg";
        break;
      case "Football":
        sportIcon = "assets/football-image.jpg";
        break;
    }
    final ThemeNotifier theme = Provider.of<ThemeNotifier>(context);
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: buildTitle(
            context,
            data['eventName'],
          ),
          leading: const BackButton(),
        ),
        body: SlidingUpPanel(
          parallaxEnabled: true,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          color: Theme.of(context).canvasColor,
          backdropEnabled: true,
          panel: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              color: Theme.of(context).canvasColor,
            ),
            child: data["status"] == "individual"
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: data["playersId"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtherUserProfile(
                                userID: data["playerInfo"][index]["friendId"],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: SizedBox(
                              height: 48,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      "assets/ProfilePlaceholder.png"),
                                  image: NetworkImage(
                                    data["playerInfo"][index]["profileImage"],
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              data["playerInfo"][index]["name"],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: data["playersId"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(data["teamInfo"][index]["teamName"]),
                        ),
                      );
                    },
                  ),
          ),
          collapsed: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              color: Theme.of(context).canvasColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    FeatherIcons.chevronsUp,
                    size: 32,
                  ),
                  Text(
                    data["status"] == "individual"
                        ? "Люди, которые присоединились"
                        : "Команды, которые присоединились",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder: eventInfoSliverAppBar,
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data["sportName"],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Text(
                              (data["playersId"].length.toString() +
                                  "/" +
                                  data["maxMembers"].toString()),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CircularProgressIndicator(
                              value:
                                  data["playersId"].length / data["maxMembers"],
                              backgroundColor: theme
                                  .currentTheme.backgroundColor
                                  .withOpacity(0.15),
                              strokeWidth: 7,
                            ),
                          ],
                        ),
                      ],
                    ),
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
                              FeatherIcons.fileText,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            data['description'].trim(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              data["type"] == 1
                                  ? FeatherIcons.globe
                                  : FeatherIcons.lock,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Text(
                          data["type"] == 1 ? "Открытая" : "Закрытая",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
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
                              FeatherIcons.calendar,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd')
                              .format(DateTime.tryParse(data["dateTime"])
                                  as DateTime)
                              .toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
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
                              FeatherIcons.clock,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat()
                              .add_jm()
                              .format(DateTime.tryParse(data["dateTime"])
                                  as DateTime)
                              .toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 124)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return const Loader();
    }
  }

  List<Widget> eventInfoSliverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 250.0,
        automaticallyImplyLeading: false,
        elevation: 0,
        floating: false,
        stretch: true,
        pinned: false,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.all(0),
          background: Image(
            width: MediaQuery.of(context).size.width,
            image: AssetImage(sportIcon!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];
  }
}
