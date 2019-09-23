import OAuthSwift
import UIKit

class LoginViewController: UIViewController {
  private var button: UIButton!
  private var oauthswift: OAuth2Swift!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    button = UIButton(type: .custom)
    button.setTitle("Log in with GitHub", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .black
    button.addTarget(self, action: #selector(tappedLogin(sender:)), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)

    oauthswift = OAuth2Swift(
      consumerKey: Secrets.OAuth.consumerKey,
      consumerSecret: Secrets.OAuth.consumerSecret,
      authorizeUrl: "https://github.com/login/oauth/authorize",
      accessTokenUrl: "https://github.com/login/oauth/access_token",
      responseType: "code"
    )
    oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    button.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
  }

  @objc func tappedLogin(sender _: UIButton) {
    oauthswift.authorize(
      withCallbackURL: URL(string: Secrets.OAuth.callbackURL)!,
      scope: "public_repo",
      state: generateState(withLength: 20)
    ) { result in
      switch result {
      case .success(let (credential, _, _)):
        KeychainOAuth().save(token: credential.oauthToken)
        AppDelegate.shared.rootViewController.showMainScreen()
      case let .failure(error):
        print(error.localizedDescription)
      }
    }
  }
}
