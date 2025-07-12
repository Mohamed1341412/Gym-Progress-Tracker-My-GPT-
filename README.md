# Gym Progress Tracker

This Flutter project targets Android, iOS, and desktop (Windows) using Firebase for authentication and data storage.

## 1. Firebase Configuration

Before running the app on a real device or emulator you must add the platform-specific Firebase configuration files **and** update the Android build scripts.

### Android

1. In the Firebase console add an Android app (package name usually `com.example.gym_progress_tracker` – match the package in `android/app/src/main/AndroidManifest.xml`).
2. Download the `google-services.json` file.
3. Copy `google-services.json` into the project at:

```
android/app/google-services.json
```

4. Update the Gradle scripts:

`android/build.gradle`
```gradle
// ... existing code ...
buildscript {
    // ... existing code ...
    dependencies {
        // Add the Google services Gradle plugin
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
// ... existing code ...
```

`android/app/build.gradle`
```gradle
plugins {
    id 'com.android.application'
    // Add this line
    id 'com.google.gms.google-services'
}

android {
    // Ensure minSdkVersion is **at least 21** for Firebase SDKs
    defaultConfig {
        minSdkVersion 21
    }
}
// ... existing code ...
```

5. Re-run `flutter pub get` then build the app:

```bash
flutterfire configure   # regenerates lib/firebase_options.dart
flutter run -d android
```

### iOS

1. Add an iOS app in the Firebase console (`bundle identifier` must match Runner target in Xcode).
2. Download `GoogleService-Info.plist`.
3. Using Xcode, drag **GoogleService-Info.plist** into the **Runner** target (make sure **Copy items if needed** is checked).
4. CocoaPods prepare step:

```bash
cd ios
pod install
cd ..
```

5. Build the app:

```bash
flutter run -d ios
```

On the first run you may be prompted to open the Xcode workspace to update signing certificates.

## 2. Regenerating `firebase_options.dart`

Whenever you add a new platform in the Firebase console or change the Firebase project, run:

```bash
flutterfire configure
```

This CLI command reads the configuration files and updates `lib/firebase_options.dart` with the correct `FirebaseOptions` for every registered platform.

## 3. Additional Notes

- For Facebook login on Android you must also provide a **Facebook App ID** and **Client Token** in `android/app/src/main/AndroidManifest.xml` – see the [Flutter Facebook Auth docs](https://pub.dev/packages/flutter_facebook_auth).
- For iOS, add the Facebook App ID and URL schemes in `ios/Runner/Info.plist`.

With the above steps in place the app will compile and connect to Firebase Authentication on both Android and iOS. 