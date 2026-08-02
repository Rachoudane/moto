import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Required by flutter_local_notifications' own iOS setup docs - without
    // this, UNUserNotificationCenter has no delegate to ask "how should I
    // present this?" while the app is in the foreground, so every
    // presentAlert/presentBanner/presentList/presentSound/presentBadge flag
    // set on the Dart side is moot: nothing shows, no sound plays, no badge
    // updates, and it never reaches Notification Center either.
    UNUserNotificationCenter.current().delegate = self
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Android has no equivalent persistent home-screen badge, so without this
  // the icon's unread count accumulates indefinitely instead of clearing
  // once the user has actually seen their reminders.
  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    if #available(iOS 16.0, *) {
      UNUserNotificationCenter.current().setBadgeCount(0)
    } else {
      application.applicationIconBadgeNumber = 0
    }
  }
}
