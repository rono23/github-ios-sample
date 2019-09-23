import UIKit

extension AppDelegate {
  static var shared: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }

  var rootViewController: RootViewController {
    return window!.rootViewController as! RootViewController
  }
}
