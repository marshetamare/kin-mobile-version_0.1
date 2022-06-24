
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  String? phoneNumber;
  final String password;
  final String passwordConfirmation;

  User(
      {required this.name,
      required this.id,
      required this.email,
      this.phoneNumber,
      required this.passwordConfirmation,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
