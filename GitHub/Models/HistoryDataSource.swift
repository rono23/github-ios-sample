import Foundation

class HistoryDataSource: NSObject {
  private let historyKey = "histories"

  func all() -> [String] {
    let userDefaults = UserDefaults.standard
    return userDefaults.stringArray(forKey: historyKey) ?? []
  }

  func count() -> Int {
    return all().count
  }

  func save(keyword: String) {
    var histories = all()
    histories.append(keyword)

    let userDefaults = UserDefaults.standard
    userDefaults.set(histories, forKey: historyKey)
    userDefaults.synchronize()
  }

  func clear() {
    UserDefaults.standard.removeObject(forKey: historyKey)
  }
}
