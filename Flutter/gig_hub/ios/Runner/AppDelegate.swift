import FBSDKCoreKit
import FirebaseCore
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 🔥 Firebase INITIALISIEREN
    FirebaseApp.configure()

    // Facebook SDK
    ApplicationDelegate.shared.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    let handledByFacebook = ApplicationDelegate.shared.application(
      app,
      open: url,
      options: options
    )

    let handledByFlutter = super.application(
      app,
      open: url,
      options: options
    )

    return handledByFacebook || handledByFlutter
  }
}
