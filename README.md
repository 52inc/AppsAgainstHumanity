# Apps Against Humanity

A Flutter Cards Against Humanity app for Android, iOS, and Web

# Usage

### Setup Firebase

Setup a [Firebase Project](https://firebase.com/) with an Android and iOS application using the appropriate steps here: https://firebase.google.com/docs

1. Download the `google-services.json` file for your Android application to `android/app/google-services.json`
2. Download the `GoogleServices-Info.plist` file for your iOS application to `ios/Runner/GoogleServices-Info.plist`
3. Add the following contents to a file named `firebase_config.js` to the `web/` folder

```javascript
// Your web app's Firebase configuration
var firebaseConfig = {
  apiKey: "some_api_key",
  authDomain: "some_firebase_project_id.firebaseapp.com",
  databaseURL: "https://some_firebase_project_id.firebaseio.com",
  projectId: "some_firebase_project_id",
  storageBucket: "some_firebase_project_id.appspot.com",
  messagingSenderId: "00000000000",
  appId: "some_web_app_id",
  measurementId: "some_analytics_id"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();
```

### Setup Wiredash
Setup an account @ [wiredash.io](https://wiredash.io/) and create a new project to generate a `projectId` and `secret` that you will use in the following config. Or, you can remove the `Wiredash` widget from the `lib/app.dart` widget tree.

### Setup Config

Add your own configuration file to the `/lib` folder. Use this example: `example.config.json`

```json
{
  "privacyPolicyUrl": "https://example.com/privacy.html",
  "termsOfServiceUrl": "https://example.com/tos.html",
  "sourceUrl": "https://github.com/52inc/AppsAgainstHumanity",
  "wiredashProjectId": "some_wiredash_projectId",
  "wiredashSecret": "some_wiredash_secret"
}
```

Then run

```shell
flutter generate
```

### Generate JSON models

Just run this:

```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Setup Functions

Fork the repository here: https://github.com/52inc/AppsAgainstHumanity-Firebase and deploy the functions to your firebase project using:

```bash
firebase deploy --only functions
```

# Contributing

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

Please follow the guidelines set forth in the [CONTRIBUTING](CONTRIBUTING.md) document.

# License

GNU General Public License v3.0

See [LICENSE](LICENSE) to see the full text.

# Attribution

All [CAH or "Cards Against Humanity"](https://cardsagainsthumanity.com/) question and answer text are hosted externally and are never included in the binary itself for the app that is uploaded to Google Play and Apple's App Store.

All [CAH or "Cards Against Humanity"](https://cardsagainsthumanity.com/) question and answer text are licensed under Creative Commons BY-NC-SA 4.0 by the owner Cards Against Humanity, LLC. This application is NOT official, produced, endorsed or supported by Cards Against Humanity, LLC.

[![CC-BY-NC-SA](assets/cc_by_nc_sa.png)](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)
