import KeychainAccess

struct KeychainOAuth {
  private let keychain: Keychain = { Keychain() }()
  private let tokenKey: String = "OAuthToken"

  public func save(token: String?) {
    keychain[tokenKey] = token
  }

  public func clear() {
    keychain[tokenKey] = nil
  }

  public func token() -> String? {
    return keychain[tokenKey]
  }

  public func hasToken() -> Bool {
    return keychain[tokenKey] != nil ? true : false
  }
}
