import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinks {
    DynamicLinks._();

    static Future<Uri> createLink(String gameDocumentId) async {
        final DynamicLinkParameters params = DynamicLinkParameters(
            uriPrefix: "https://appsagainsthumanity.com/games",
            link: Uri.parse("https://appsagainsthumanity.com/games/$gameDocumentId"),
            androidParameters: AndroidParameters(
                packageName: 'com.ftinc.appsagainsthumanity',
            ),
            iosParameters: IosParameters(
                appStoreId: "1509268296",
                bundleId: "com.ftinc.appsagainsthumanity",
            ),
            socialMetaTagParameters: SocialMetaTagParameters(
                title: "Come join my game!",
                description: "Play a game of Apps Against Humanity",
            ),
        );

        var shortLink = await params.buildShortLink();
        return shortLink.shortUrl;
    }

    static void initDynamicLinks(BuildContext context, void Function(String gameId) callback) async {
        final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
        final Uri deepLink = data?.link;

        if (deepLink != null) {
            var lastSegment = deepLink.pathSegments.last;
            if (lastSegment != null) {
                print("Joining $lastSegment from dynamic link");
                callback(lastSegment);
            }
        }

        FirebaseDynamicLinks.instance.onLink(
            onSuccess: (PendingDynamicLinkData dynamicLink) async {
                final Uri deepLink = dynamicLink?.link;

                if (deepLink != null) {
                    var lastSegment = deepLink.pathSegments.last;
                    if (lastSegment != null) {
                        print("Joining $lastSegment from dynamic link");
                        callback(lastSegment);
                    }
                }
            },
            onError: (OnLinkErrorException e) async {
                print('onLinkError');
                print(e.message);
            }
        );
    }
}
