import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ipsewallet/app.dart';
import 'package:ipsewallet/service/notification.dart';
import 'package:ipsewallet/widgets/restart_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<Null> main() async {
 

  
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      android:initializationSettingsAndroid, iOS:initializationSettingsIOS);
   await flutterLocalNotificationsPlugin.initialize(
      initializationSettings, onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  await GetStorage.init();

  if (isInDebugMode) {
    runApp(RestartWidget(child: IpseApp()));
  } else {
    await SentryFlutter.init((options) {
      options.dsn =
          "https://484adc7fa91f4b4d866bb12222f3a953@o482555.ingest.sentry.io/5532969";
    }, appRunner: () => runApp(RestartWidget(child: IpseApp())));
  }

  
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}
