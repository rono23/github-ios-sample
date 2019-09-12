struct Repository: Decodable {
  let id: Int
  let owner: User
  let fullName: String
  let htmlURL: String
  let stargazersCount: Int

  enum CodingKeys: String, CodingKey {
    case id
    case owner
    case fullName = "full_name"
    case htmlURL = "html_url"
    case stargazersCount = "stargazers_count"
  }
}
