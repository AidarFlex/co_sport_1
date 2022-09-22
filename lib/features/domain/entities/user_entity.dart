import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String username;
  final String fullName;
  final String profileImage;
  final String location;
  final String bio;

  const UserEntity(
      {required this.userId,
      required this.username,
      required this.fullName,
      required this.profileImage,
      required this.location,
      required this.bio});

  @override
  List<Object?> get props => [
        userId,
        username,
        fullName,
        profileImage,
        location,
        bio,
      ];
}
