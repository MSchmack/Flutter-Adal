import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutteradal/flutteradal.dart';
import 'package:flutteradal_example/config.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Flutteradal.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  AdalAuthContext authContext;
  test() async {
    authContext = await Flutteradal.adalLogin(
        authority: BoschADFS.authority,
        resourceUrl: BoschADFS.resourceUrl,
        clientId: BoschADFS.clientId,
        redirectUrl: BoschADFS.redirectUrl);
    setState(() {});
  }
  test2() async {
    var s = await Flutteradal.adalGetToken();
    setState(() {});
  }

  ifNotNullElseBlank(String value) {
    return value == "" || value == null ? "" : value;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Running on: $_platformVersion\n'),
                RaisedButton(
                  child: Text("Hi"),
                  onPressed: () async => test(),
                ),
                RaisedButton(
                  child: Text("HiHo"),
                  onPressed: () async => test2(),
                ),
                this.authContext == null
                    ? Container()
                    : Card(
                        child: Column(
                          children: <Widget>[
                            this.authContext.isSuccess
                                ? Icon(Icons.check)
                                : Icon(Icons.error_outline),
                            Text(ifNotNullElseBlank(authContext?.errorType)),
                            Divider(
                              height: 15.0,
                              color: Colors.lightBlue,
                            ),
                            Text(ifNotNullElseBlank(
                                authContext?.expiresOn?.toLocal().toString())),
                            Divider(
                              height: 15.0,
                              color: Colors.lightBlue,
                            ),
                            Text(ifNotNullElseBlank(authContext?.refreshToken)),
                            Divider(
                              height: 15.0,
                              color: Colors.lightBlue,
                            ),
                            Text(ifNotNullElseBlank(authContext?.accessToken))
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
