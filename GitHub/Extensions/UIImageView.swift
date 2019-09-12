import UIKit

extension UIImageView {
  static let imageCache = NSCache<NSString, UIImage>()

  func setImageWithCache(URLString: String) {
    let cacheKey = NSString(string: URLString)
    image = nil

    if let cacheImage = UIImageView.imageCache.object(forKey: cacheKey) {
      image = cacheImage
      return
    }

    DispatchQueue.global().async {
      guard let url = URL(string: URLString), let data = try? Data(contentsOf: url) else {
        return
      }

      if let image = UIImage(data: data) {
        UIImageView.imageCache.setObject(image, forKey: cacheKey)
        DispatchQueue.main.async {
          self.image = image
        }
      }
    }
  }
}
