import 'dart:convert';

class LoginResponseModel {
  LoginResponseModel({
    required this.accessToken,
    required this.refreshAccessToken,
  });

  final String accessToken;
  final String refreshAccessToken;

  factory LoginResponseModel.fromJson(String str) =>
      LoginResponseModel.fromMap(json.decode(str) as Map<String, dynamic>);

  factory LoginResponseModel.fromMap(Map<String, dynamic> json) =>
      LoginResponseModel(
        accessToken: json['access_token'] as String,
        refreshAccessToken: json['refresh_access_token'] as String,
      );

  Map<String, dynamic> toMap() => {
        'access_token': accessToken,
        'refresh_access_token': refreshAccessToken,
      };
}
