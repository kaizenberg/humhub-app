import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humhub/models/hum_hub.dart';
import 'package:humhub/models/manifest.dart';
import 'package:humhub/pages/help/help.dart';
import 'package:humhub/pages/opener.dart';
import 'package:humhub/pages/web_view.dart';
import 'package:humhub/util/providers.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

NavigatorState? get navigator => navigatorKey.currentState;

List<Map> _pendingRoutes = [];

/// Queue any route, this route is pushed on stack after app has initialized.
/// This usually means after user is logged in and assets are downloaded
void queueRoute(
  String routeName, {
  Object? arguments,
}) {
  _pendingRoutes.add({
    'route': routeName,
    'arguments': arguments,
  });
}

class MyRouter {
  static String? initRoute;
  static dynamic initParams;

  static var routes = {
    Opener.path: (context) => const Opener(),
    WebViewApp.path: (context) => const WebViewApp(),
    Help.path: (context) => const Help(),
  };

  static Future<String> getInitialRoute(WidgetRef ref) async {
    HumHub humhub = await ref.read(humHubProvider).getInstance();
    RedirectAction action = await humhub.action(ref);
    switch (action) {
      case RedirectAction.opener:
        initRoute = Opener.path;
        return Opener.path;
      case RedirectAction.webView:
        initRoute = WebViewApp.path;
        initParams = humhub.manifest;
        return WebViewApp.path;
    }
  }
}

class ManifestWithRemoteMsg {
  final Manifest _manifest;
  final RemoteMessage _remoteMessage;

  RemoteMessage get remoteMessage => _remoteMessage;
  Manifest get manifest => _manifest;

  ManifestWithRemoteMsg(this._manifest, this._remoteMessage);
}
