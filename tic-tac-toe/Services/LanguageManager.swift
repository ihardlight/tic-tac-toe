import Foundation

private let DEFAULT_LANGUAGE = "en"

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    private let languageKey = "selectedLanguage"
    let availableLanguages = [DEFAULT_LANGUAGE, "ru"]
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: languageKey)
        }
    }
    
    init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
           availableLanguages.contains(savedLanguage) {
            currentLanguage = savedLanguage
        } else {
            currentLanguage = Locale.current.language.languageCode?.identifier ?? DEFAULT_LANGUAGE
        }
    }
}
