import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
            Bundle.setLanguage(selectedLanguage)
        }
    }

    private init() {
        let saved = UserDefaults.standard.string(forKey: "selectedLanguage")
        self.selectedLanguage = saved ?? Locale.current.languageCode ?? "en"
        Bundle.setLanguage(self.selectedLanguage)
    }
}

extension Bundle {
    private static var bundleKey: UInt8 = 0

    static func setLanguage(_ language: String) {
        object_setClass(Bundle.main, PrivateBundle.self)
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: Bundle.main.path(forResource: language, ofType: "lproj")!), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    private class PrivateBundle: Bundle {
        override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
            let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle
            return bundle?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}