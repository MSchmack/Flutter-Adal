import 'dart:async';

import 'package:flutter/services.dart';

class Flutteradal {
  static MethodChannel _channel = const MethodChannel('flutteradal')
    ..setMethodCallHandler((MethodCall call) async {
      print(call.method.toString());
      print("returned call method");
    });

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void asd;
  static Future<AdalAuthContext> adalGetToken() async {
    dynamic res = await _channel.invokeMethod('adalGetToken');
    print(res.toString());
    return res;
  }
  static Future<AdalAuthContext> adalSilentLogin() async {
    dynamic res = await _channel.invokeMethod('adalSilentLogin');
    print(res.toString());
    return res;
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
    print("asd");

    asd = _channel
        .setMethodCallHandler((MethodCall call) async => setResult(call));
    AdalAuthContext res = AdalAuthContext.fromObject(
        await _channel.invokeMethod('adalLoginSilent', args));
    if (!res.isSuccess) {
      res = AdalAuthContext.fromObject(
          await _channel.invokeMethod('adalLogin', args));
    }
    return res;
    return null;
  }

  static setResult(dynamic o) {
    print("result ${o.toString()}");

    asd = _channel
        .setMethodCallHandler((MethodCall call) async => setResult(call));
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
