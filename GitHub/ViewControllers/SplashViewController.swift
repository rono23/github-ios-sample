import UIKit

class SplashViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if KeychainOAuth().hasToken() {
      AppDelegate.shared.rootViewController.showMainScreen()
    } else {
      AppDelegate.shared.rootViewController.showLoginScreen()
    }
  }
}
