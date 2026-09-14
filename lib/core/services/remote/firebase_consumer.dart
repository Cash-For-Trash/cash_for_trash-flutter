import 'dart:ui';
import 'dart:developer';
import 'package:cash_for_trash/core/services/local/cache_helper.dart';
import 'package:cash_for_trash/core/services/remote/endpoints.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import '../../../firebase_options.dart';

import 'api_consumer.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log("Handling background message: ${message.messageId}");
}

class FirebaseConsumer {
  final ApiConsumer apiConsumer;
  final CacheHelper cacheHelper;
  FirebaseConsumer({required this.apiConsumer, required this.cacheHelper});

  Future<void> initFirebase() async {
    log("Init Firebase Join");
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log('main: Firebase initialized');

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } catch (e) {
      log('main: Error initializing Firebase - $e', error: e);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    String? storedFcmToken = await CacheHelper.getSecretData(
      key: ApiKey.fcmToken,
    );

    log("FCM TOKEN Stored: $storedFcmToken");

    if (storedFcmToken == null || storedFcmToken.isEmpty) {
      try {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        log("FCM TOKEN Generated: $fcmToken");

        if (fcmToken != null) {
          try {
            await CacheHelper.saveSecretData(key: ApiKey.fcmToken, value: fcmToken);
          } catch (e) {
            log("main: Exception saving FCM token - $e", error: e);
          }
        }
      } catch (e) {
        log('main: Error getting FCM token - $e', error: e);
      }
    }
  }
}