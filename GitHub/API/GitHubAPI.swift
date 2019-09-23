import Foundation

class GitHubAPI {
  enum Sort: String {
    case created, updated
    static let allValues = [created, updated]
  }

  struct SearchRepositories: GitHubRequest {
    typealias Response = [Repository]
    let keyword: String
    let sort: Sort

    var method: HTTPMethod {
      return .get
    }

    var path: String {
      return "/user/repos"
    }

    var queryItems: [URLQueryItem] {
      return [
        URLQueryItem(name: "q", value: keyword),
        URLQueryItem(name: "sort", value: sort.rawValue),
        URLQueryItem(name: "direction", value: "desc"),
        URLQueryItem(name: "per_page", value: "1000"),
      ]
    }
  }
}
