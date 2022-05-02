import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinks {
  DynamicLinks._();

  static Future<Uri> createLink(String gameDocumentId) async {
    if (!kIsWeb) {
      final DynamicLinkParameters params = DynamicLinkParameters(
        uriPrefix: "https://appsagainsthumanity.com/games",
        link:
            Uri.parse("https://appsagainsthumanity.com/games/$gameDocumentId"),
        androidParameters: AndroidParameters(
          packageName: 'com.ftinc.appsagainsthumanity',
        ),
        iosParameters: IOSParameters(
          appStoreId: "1509268296",
          bundleId: "com.ftinc.appsagainsthumanity",
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: "Come join my game!",
          description: "Play a game of Apps Against Humanity",
        ),
      );

      var shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(params);
      return Uri.parse(shortLink.toString());
    } else {
      return Uri.parse("https://appsagainsthumanity.com/games/$gameDocumentId");
    }
  }

  static void initDynamicLinks(
      BuildContext context, void Function(String gameId) callback) async {
    if (!kIsWeb) {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data!.link;

      if (deepLink != "") {
        var lastSegment = deepLink.pathSegments.last;
        if (lastSegment != "") {
          print("Joining $lastSegment from dynamic link");
          callback(lastSegment);
        }
      }

      FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
        final Uri deepLink = dynamicLink.link;

        if (deepLink != "") {
          var lastSegment = deepLink.pathSegments.last;
          if (lastSegment != "") {
            print("Joining $lastSegment from dynamic link");
            callback(lastSegment);
          }
        }
      }).onError((error) async {
        print('onLinkError');
        print(error.message);
      });
    }
  }
}
