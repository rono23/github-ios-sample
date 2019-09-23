import UIKit

class HistoryViewController: UIViewController {
  private var tableView: UITableView!
  private var searchController: UISearchController!
  private var allHistories: [String?] = []
  private var filteredHistories: [String?] = []
  private let historyDataSource = HistoryDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "History"

    tableView = UITableView(frame: view.bounds, style: .plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
    tableView.keyboardDismissMode = .onDrag
    view.addSubview(tableView)

    searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    definesPresentationContext = true

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearHistories(sender:)))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout(sender:)))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    allHistories = historyDataSource.all().reversed()
    tableView.reloadData()
  }

  @objc func clearHistories(sender _: UIBarButtonItem) {
    historyDataSource.clear()
    allHistories = []
    filteredHistories = []
    tableView.reloadData()
  }

  @objc func logout(sender _: UIBarButtonItem) {
    AppDelegate.shared.rootViewController.showLoginScreenAfterLogout()
  }

  private func isSearchBarEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }

  private func histories() -> [String?] {
    return isSearchBarEmpty() ? allHistories : filteredHistories
  }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in _: UITableView) -> Int {
    return 1
  }

  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return 45
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return histories().count
  }

  func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as UITableViewCell

    if let history = histories()[indexPath.row] {
      cell.textLabel?.text = history
    }

    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)

    guard let VCs = tabBarController?.viewControllers,
      let navVC = VCs[0] as? UINavigationController,
      let repositoryVC = navVC.topViewController as? RepositoryViewController else {
      return
    }

    if let keyword = histories()[indexPath.row],
      let text = repositoryVC.searchBar.text,
      text != keyword {
      repositoryVC.searchBar.text = keyword
      repositoryVC.searchRepositories()
    }

    tabBarController?.selectedIndex = 0
  }
}

extension HistoryViewController: UISearchResultsUpdating {
  func updateSearchResults(for _: UISearchController) {
    let keyword = searchController.searchBar.text!
    filteredHistories = allHistories.filter { $0!.lowercased().contains(keyword.lowercased()) }
    tableView.reloadData()
  }
}
