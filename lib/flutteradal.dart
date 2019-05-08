import 'dart:async';

import 'package:flutter/services.dart';

class Flutteradal {
  static const MethodChannel _channel = const MethodChannel('flutteradal');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<AdalAuthContext> adalLogin(
      {String authority,
      String clientId,
      String redirectUrl,
      String resourceUrl}) async {
    var args = {
      "authority": authority,
      "clientId": clientId,
      "redirectUrl": redirectUrl,
      "resourceUrl": resourceUrl
    };

    AdalAuthContext res = AdalAuthContext.fromObject(
        await _channel.invokeMethod('adalLoginSilent', args));
    if (!res.isSuccess) {
      res = AdalAuthContext.fromObject(
          await _channel.invokeMethod('adalLogin', args));
    }
    return res;
  }
}

class AdalAuthContext {
  String accessToken;
  DateTime expiresOn;
  bool isSuccess;
  String refreshToken;
  String errorType;

  AdalAuthContext.fromObject(dynamic o) {
    this.accessToken = o["accessToken"];
    this.refreshToken = o["refreshToken"];
    this.expiresOn = DateTime.tryParse(o["expiresOn"]);
    this.isSuccess = o["isSuccess"];
    this.errorType = o["errorType"];
  }
}
