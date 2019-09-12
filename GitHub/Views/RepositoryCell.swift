import UIKit

class RepositoryCell: UITableViewCell {
  private var avatarView: UIImageView!
  private var fullNameLabel: UILabel!
  private var stargazersCountLabel: UILabel!

  required init?(coder _: NSCoder) {
    fatalError()
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    avatarView = UIImageView()
    avatarView.clipsToBounds = true
    contentView.addSubview(avatarView)

    fullNameLabel = UILabel()
    fullNameLabel.font = UIFont.systemFont(ofSize: 15)
    contentView.addSubview(fullNameLabel)

    stargazersCountLabel = UILabel()
    stargazersCountLabel.font = UIFont.systemFont(ofSize: 12)
    stargazersCountLabel.textColor = .gray
    contentView.addSubview(stargazersCountLabel)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    avatarView.frame = CGRect(x: 15, y: 13, width: 35, height: 35)
    avatarView.layer.cornerRadius = avatarView.frame.size.width / 2
    fullNameLabel.frame = CGRect(x: avatarView.frame.maxX + 15,
                                 y: avatarView.frame.origin.y,
                                 width: contentView.frame.width - avatarView.frame.maxX - 15 * 2,
                                 height: 17)
    stargazersCountLabel.frame = CGRect(x: fullNameLabel.frame.origin.x,
                                        y: fullNameLabel.frame.origin.y + 23,
                                        width: fullNameLabel.frame.width,
                                        height: 10)
  }

  func set(_ repository: Repository) {
    avatarView.setImageWithCache(URLString: repository.owner.avatarURL)
    fullNameLabel.text = repository.fullName
    stargazersCountLabel.text = "☆ \(repository.stargazersCount)"
  }
}
