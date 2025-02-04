import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String email;
  final String userId;
  final String name;

  const UserModel({
    required this.email,
    required this.userId,
    required this.name,
  });
  UserModel copyWith({
    String? email,
    String? userId,
    String? name,
  }) {
    return UserModel(
      email: email ?? this.email,
      userId: userId ?? this.userId,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [email, userId, name];
}
