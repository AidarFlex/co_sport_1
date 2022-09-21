import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String username;

  const UserEntity({required this.userId, required this.username});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
