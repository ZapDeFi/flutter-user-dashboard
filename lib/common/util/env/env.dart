import 'dart:io';

abstract class Env {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
  String get host;
}
