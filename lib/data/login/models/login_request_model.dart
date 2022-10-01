import 'dart:convert';

class LoginRequestModel {
  LoginRequestModel({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  factory LoginRequestModel.fromJson(String str) =>
      LoginRequestModel.fromMap(json.decode(str) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  factory LoginRequestModel.fromMap(Map<String, dynamic> json) =>
      LoginRequestModel(
        username: json['username'] as String,
        password: json['password'] as String,
      );

  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
      };
}
