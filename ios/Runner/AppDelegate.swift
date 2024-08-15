import Flutter
import UIKit
import FirebaseCore  // إضافة هذا السطر إذا كنت تستخدم Firebase
import UserNotifications  // إضافة هذا السطر إذا كنت تستخدم إشعارات الدفع

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase if you're using Firebase
    FirebaseApp.configure()

    // Request permission for push notifications (if needed)
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if let error = error {
        print("Failed to request authorization for push notifications: \(error.localizedDescription)")
        return
      }
      print("Push notification permission granted: \(granted)")
    }
    
    // Register for remote notifications
    application.registerForRemoteNotifications()

    // Register the plugins
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle incoming notifications (if needed)
  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [String: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    // Handle the notification
    super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }
}
