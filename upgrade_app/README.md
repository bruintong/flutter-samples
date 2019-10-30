# upgrade_app

A new Flutter project.

## Flutter 下载更新APP

iOS 跟 Android 更新完全不一样。iOS 只能跳转到 AppStore，比较好实现。Android 则需要下载 apk 包，这里使用 [AppUpdater](https://github.com/jenly1314/AppUpdater) 下载 apk 包。

### iOS

iOS 直接采用 url_launcher 打开 AppStore

``` dart
if (Platform.isIOS) {
  final String url = 'https://itunes.apple.com/cn/app/[:id]';
  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false);
  } else {
    throw 'Could not launch $url';
  }
}
```

### Android

在 **android/app/build.gradle** 文件添加下载库

``` gradle
dependencies {
    /* ----------  app-updater  ---------- */
    implementation 'com.king.app:app-updater:1.0.5-androidx'
}
```

在 **AndroidManifest.xml** 添加存储权限

``` xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

在 Android 项目中编写插件

``` java
public class UpdateVersionPlugin implements EventChannel.StreamHandler {

  private static String TAG = "MY_UPDATE";
  private static Context context;

  public UpdateVersionPlugin(Context context) {
      this.context = context;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
      final EventChannel channel = new EventChannel(registrar.messenger(), "plugins.example.com/update_version");
      channel.setStreamHandler(new UpdateVersionPlugin(registrar.context()));
  }


  @Override
  public void onListen(Object o, EventChannel.EventSink eventSink) {

      if (o.toString().length() < 5) {
          eventSink.error(TAG, "URL错误", o);
          return;
      }
      if (!o.toString().startsWith("http")){
          eventSink.error(TAG, "URL错误", o);
          return;
      }

      AppUpdater update = new AppUpdater(context,o.toString()).setUpdateCallback(new UpdateCallback() {

          Map data = new HashMap<String, Object>();

          // 发送数据到 Flutter
          private  void sendData() {
              eventSink.success(data);
          }

          @Override
          public void onDownloading(boolean isDownloading) {

          }

          @Override
          public void onStart(String url) {
              data.put("start", true);
              data.put("cancel", false);
              data.put("done",false );
              data.put("error", false);
              data.put("percent", 1);
              sendData();
          }

          @Override
          public void onProgress(int progress, int total, boolean isChange) {
              int percent = (int)(progress * 1.0 / total * 100);
              if (isChange && percent > 0) {
                  data.put("percent", percent);
                  sendData();
              }
          }

          @Override
          public void onFinish(File file) {
              data.put("done", true);
              sendData();
          }

          @Override
          public void onError(Exception e) {
              data.put("error", e.toString());
              sendData();
          }

          @Override
          public void onCancel() {
              data.put("cancel", true);
              sendData();
          }
      });
      update.start();
  }

  @Override
  public void onCancel(Object o) {
      update.stop();
  }

}
```

在 **MainActivity.java** 文件中注册插件
``` java
// 注册更新组件
UpdateVersionPlugin.registerWith(registrarFor("example.com/update_version"));
```

采用 **EventChannel** 来持续单项通讯
``` dart
static const stream =
    const EventChannel('plugins.example.com/update_version');

StreamSubscription downloadSubscription;

void _upgradeApp() async {
  Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
  if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
    if (downloadSubscription == null) {
      downloadSubscription = stream
          .receiveBroadcastStream(
              'https://www.example.com/app-latest.apk')
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
```

在 **pubspec.yaml** 文件添加依赖
``` yaml
dependencies:
  flutter:
    sdk: flutter

  url_launcher: ^5.1.2
  permission_handler: ^3.2.2
```
