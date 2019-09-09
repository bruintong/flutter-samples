import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Upgrade App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const stream =
      const EventChannel('plugins.example.com/update_version');

  StreamSubscription downloadSubscription;

  void _upgradeApp() async {
    if (Platform.isIOS) {
      final String url = 'https://itunes.apple.com/cn/app/id1442790272';
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false);
      } else {
        throw 'Could not launch $url';
      }
    } else if (Platform.isAndroid) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        if (downloadSubscription == null) {
          downloadSubscription = stream
              .receiveBroadcastStream(
                  'https://backend.lanjingerp.com/user/rest/com.ihoment.lanjingerp-app-latest.apk')
              .listen(_updateDownloadState);
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('下载更新包需要打开存储权限'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('取消'),
                  ),
                  new FlatButton(
                    onPressed: () {
                      PermissionHandler().openAppSettings();
                      Navigator.of(context).pop();
                    },
                    child: new Text('确定'),
                  )
                ],
              );
            });
      }
    }
  }

  _updateDownloadState(data) {
    int progress = data['percent'];
    if (progress != null) {
      print(progress);
    }
  }

  _stopDownload() {
    if (downloadSubscription != null) {
      downloadSubscription.cancel();
      downloadSubscription = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stopDownload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Upgrade App',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _upgradeApp,
        tooltip: 'Upgrade App',
        child: Icon(Icons.update),
      ),
    );
  }
}
