import OAuthSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_: UIApplication,
                   didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = window ?? UIWindow()
    window!.rootViewController = RootViewController()
    window!.makeKeyAndVisible()
    return true
  }

  func application(_: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if options[.sourceApplication] as? String == "com.apple.SafariViewService", url.host == Secrets.OAuth.host {
      OAuthSwift.handle(url: url)
    }

    return true
  }

  func applicationWillResignActive(_: UIApplication) {}

  func applicationDidEnterBackground(_: UIApplication) {}

  func applicationWillEnterForeground(_: UIApplication) {}

  func applicationDidBecomeActive(_: UIApplication) {}

  func applicationWillTerminate(_: UIApplication) {}
}
