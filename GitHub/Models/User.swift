struct User: Decodable {
  let id: Int
  let login: String
  let avatarURL: String
  let htmlURL: String

  enum CodingKeys: String, CodingKey {
    case id
    case login
    case avatarURL = "avatar_url"
    case htmlURL = "html_url"
  }
}
