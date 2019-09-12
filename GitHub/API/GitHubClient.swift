import Foundation

class GitHubClient {
  private let session: URLSession = {
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    return session
  }()

  func send<Request: GitHubRequest>(request: Request, completion: @escaping (Result<Request.Response, GitHubClientError>) -> Void) {
    let urlRequest = request.buildURLRequest()
    let task = session.dataTask(with: urlRequest) { data, response, error in
      if let error = error {
        DispatchQueue.main.async {
          completion(.failure(.connectionError(error)))
        }
        return
      }

      guard let response = response, let data = data else {
        let error = NSError(domain: "error", code: 0, userInfo: nil)
        DispatchQueue.main.async {
          completion(.failure(.connectionError(error)))
        }
        return
      }

      do {
        let response = try request.response(from: data, urlResponse: response)
        DispatchQueue.main.async {
          completion(.success(response))
        }
      } catch let error as GitHubAPIError {
        DispatchQueue.main.async {
          completion(.failure(.connectionError(error)))
        }
      } catch {
        DispatchQueue.main.async {
          completion(.failure(.responseParseError(error)))
        }
      }
    }

    task.resume()
  }
}
