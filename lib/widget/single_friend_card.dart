import 'package:co_sport_map/view/profile/other_user_profile.dart';
import 'package:flutter/material.dart';

class SingleFriendCard extends StatelessWidget {
  final String imageLink;
  final String name;
  final String userId;

  const SingleFriendCard({
    required this.imageLink,
    required this.name,
    required this.userId,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Card(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUserProfile(
                  userID: userId,
                ),
              ),
            );
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: SizedBox(
                    height: 48,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(imageLink, height: 48),
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
