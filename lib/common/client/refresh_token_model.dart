import 'dart:convert';

class RefreshTokenModel {
  final String? token;
  final String? refreshToken;

  const RefreshTokenModel({
    required this.token,
    required this.refreshToken,
  });

  factory RefreshTokenModel.fromJson(String str) => RefreshTokenModel.fromMap(
        json.decode(str) as Map<String, dynamic>,
      );

  factory RefreshTokenModel.fromMap(Map<String, dynamic> json) =>
      RefreshTokenModel(
        token: json["token"] as String?,
        refreshToken: json["refresh_token"] as String?,
      );
}
