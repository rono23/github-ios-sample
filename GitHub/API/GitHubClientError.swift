enum GitHubClientError: Error {
  case apiError(GitHubAPIError)
  case connectionError(Error)
  case responseParseError(Error)
}
