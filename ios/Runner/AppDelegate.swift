import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey('AIzaSyD8sogsU7v7x-8yG8BJJs-2v3jgapXd9Qo');
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
