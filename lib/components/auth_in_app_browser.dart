import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:humhub/models/manifest.dart';
import 'package:humhub/util/extensions.dart';
import 'package:loggy/loggy.dart';

class AuthInAppBrowser extends InAppBrowser {
  final Manifest manifest;
  late InAppBrowserClassOptions options;
  final Function concludeAuth;

  AuthInAppBrowser({required this.manifest, required this.concludeAuth}) {
    options = InAppBrowserClassOptions(
      crossPlatform: InAppBrowserOptions(hideUrlBar: false, toolbarTopBackgroundColor: HexColor(manifest.themeColor)),
      inAppWebViewGroupOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(javaScriptEnabled: true, useShouldOverrideUrlLoading: true),
      ),
    );
  }

  @override
  Future<NavigationActionPolicy?>? shouldOverrideUrlLoading(NavigationAction navigationAction) async {
    logInfo("Browser closed!");

    if (navigationAction.request.url!.origin.startsWith(manifest.baseUrl)) {
      concludeAuth(navigationAction.request);
      return NavigationActionPolicy.CANCEL;
    }
    return NavigationActionPolicy.ALLOW;
  }

  launchUrl(URLRequest urlRequest) {
    openUrlRequest(urlRequest: urlRequest, options: options);
  }


}
