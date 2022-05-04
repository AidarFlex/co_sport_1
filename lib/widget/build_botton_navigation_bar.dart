import 'package:co_sport_map/view/chats/message_page.dart';
import 'package:co_sport_map/view/explore_events/explore_events.dart';
import 'package:co_sport_map/view/notifications_page.dart';
import 'package:co_sport_map/view/profile/profile_page.dart';
import 'package:co_sport_map/view/teams/teams_page.dart';
import 'package:co_sport_map/widget/show_offline.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AnimatedBottomBar extends StatefulWidget {
  const AnimatedBottomBar({Key? key}) : super(key: key);

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar> {
  late int _currentPage;

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(_currentPage),
      bottomNavigationBar: AnimatedBottomNav(
          currentIndex: _currentPage,
          onChange: (index) {
            setState(() {
              _currentPage = index;
            });
          }),
    );
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return const ExploreEvents();
      case 1:
        return const MessagePage();
      case 2:
        return const TeamsList();
      case 3:
        return const Notifications();
      case 4:
        return const Profile();
    }
  }
}

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;
  const AnimatedBottomNav(
      {Key? key, required this.currentIndex, required this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .bottomNavigationBarTheme
            .backgroundColor
            ?.withOpacity(0.3),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(0),
              child: BottomNavItem(
                icon: FeatherIcons.compass,
                title: "Эвенты",
                isActive: currentIndex == 0,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(1),
              child: BottomNavItem(
                icon: FeatherIcons.messageSquare,
                title: "Сообщения",
                isActive: currentIndex == 1,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: FeatherIcons.users,
                title: "Команды",
                isActive: currentIndex == 2,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(3),
              child: BottomNavItem(
                icon: FeatherIcons.bell,
                title: "Oповещения",
                isActive: currentIndex == 3,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onChange(4),
              child: BottomNavItem(
                icon: FeatherIcons.user,
                title: "Профиль",
                isActive: currentIndex == 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color? activeColor;
  final Color? inactiveColor;
  final String title;
  const BottomNavItem(
      {Key? key,
      this.isActive = false,
      required this.icon,
      this.activeColor,
      this.inactiveColor,
      required this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
      child: isActive
          ? Container(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      title,
                      softWrap: false,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: activeColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    width: 5.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              height: kToolbarHeight,
              child: Icon(
                icon,
                color: inactiveColor,
              ),
            ),
    );
  }
}
