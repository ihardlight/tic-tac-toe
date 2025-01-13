import Foundation

extension String {
    func localized(comment: String = "") -> String {
        guard let path = Bundle.main.path(forResource: LanguageManager.shared.currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return self
        }

        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: comment)
    }
}
