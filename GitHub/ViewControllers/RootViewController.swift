import UIKit

class RootViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let repositoryVC = RepositoryViewController()
    repositoryVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    let repositoryNavVC = UINavigationController(rootViewController: repositoryVC)

    let historyVC = HistoryViewController()
    historyVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
    let historyNavVC = UINavigationController(rootViewController: historyVC)

    setViewControllers([repositoryNavVC, historyNavVC], animated: false)
  }
}
