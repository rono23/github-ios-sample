import SafariServices
import UIKit

class RepositoryViewController: UIViewController {
  var searchBar: UISearchBar!
  private var tableView: UITableView!
  private var refreshControl: UIRefreshControl!
  private var activityIndicatorView: UIActivityIndicatorView!
  private var repositories = [Repository]()
  private var sortParam: GitHubAPI.Sort = .created
  private let historyDataSource = HistoryDataSource()
  private let client: GitHubClient = GitHubClient()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Repository"
    tableView = UITableView(frame: view.bounds, style: .plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(RepositoryCell.self, forCellReuseIdentifier: "RepositoryCell")
    tableView.keyboardDismissMode = .onDrag
    view.addSubview(tableView)

    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange(sender:)), for: .valueChanged)
    tableView.refreshControl = refreshControl

    searchBar = UISearchBar()
    searchBar.sizeToFit()
    searchBar.delegate = self
    tableView.tableHeaderView = searchBar

    activityIndicatorView = UIActivityIndicatorView(style: .medium)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortRepositories(sender:)))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  @objc func refreshControlValueDidChange(sender _: UIRefreshControl) {
    searchRepositories()
  }

  @objc func sortRepositories(sender _: UIBarButtonItem) {
    let alertVC = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)

    for value in GitHubAPI.Sort.allValues {
      var title = value.rawValue.capitalized

      if sortParam == value {
        title = "✓  \(title)"
      }

      alertVC.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
        if self?.sortParam == value {
          return
        }
        self?.sortParam = value
        self?.searchRepositories(withSaving: false)
      })
    }
    alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alertVC, animated: true)
  }

  func searchRepositories(withSaving isSave: Bool = true) {
    guard let keyword = searchBar.text, !keyword.isEmpty else {
      refreshControl.endRefreshing()
      return
    }

    if !refreshControl.isRefreshing {
      activityIndicatorView.startAnimating()
    }

    if isSave {
      historyDataSource.save(keyword: keyword)
    }

    let request = GitHubAPI.SearchRepositories(keyword: keyword, sort: sortParam)

    client.send(request: request) { [weak self] result in
      switch result {
      case let .success(response):
        self?.repositories.removeAll()

        for repo in response {
          self?.repositories.append(repo)
        }

        self?.tableView.reloadData()
      case let .failure(.connectionError(error)):
        print("ConnectionError: \(error)")
      case let .failure(.responseParseError(error)):
        print("ParseError: \(error)")
      case let .failure(.apiError(error)):
        print("APIError: \(error)")
      }

      self?.activityIndicatorView.stopAnimating()
      self?.refreshControl.endRefreshing()
    }
  }
}

extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in _: UITableView) -> Int {
    return 1
  }

  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return 60
  }

  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return repositories.count
  }

  func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
    let repository = repositories[indexPath.row]
    cell.set(repository)
    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    let repository = repositories[indexPath.row]
    let webVC = SFSafariViewController(url: URL(string: repository.htmlURL)!)
    present(webVC, animated: true, completion: nil)
  }
}

extension RepositoryViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchRepositories()
    searchBar.endEditing(true)
  }
}
