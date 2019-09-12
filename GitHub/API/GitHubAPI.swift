import Foundation

class GitHubAPI {
  enum Sort: String {
    case stars, created, updated
    static let allValues = [stars, created, updated]
  }

  struct SearchRepositories: GitHubRequest {
    typealias Response = SearchResponse<Repository>
    let keyword: String
    let sort: Sort

    var method: HTTPMethod {
      return .get
    }

    var path: String {
      return "/search/repositories"
    }

    var queryItems: [URLQueryItem] {
      return [
        URLQueryItem(name: "q", value: keyword),
        URLQueryItem(name: "sort", value: sort.rawValue),
      ]
    }
  }

  struct SearchUsers: GitHubRequest {
    typealias Response = SearchResponse<User>
    let keyword: String

    var method: HTTPMethod {
      return .get
    }

    var path: String {
      return "/search/users"
    }

    var queryItems: [URLQueryItem] {
      return [URLQueryItem(name: "q", value: keyword)]
    }
  }
}
