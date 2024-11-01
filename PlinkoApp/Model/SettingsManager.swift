
import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    
    private let selectedOptionKey = "selectedNotificationOption"
    
    func saveSelectedOption(_ option: Int) {
        UserDefaults.standard.set(option, forKey: selectedOptionKey)
        
    }
    
    func loadSelectedOption() -> Int? {
        return UserDefaults.standard.value(forKey: selectedOptionKey) as? Int
    }
}

// Enum для представления частоты уведомлений
enum NotificationFrequency: String {
    case never = "Never"
    case everyHour = "Every Hour"
    case every4Hours = "Every 4 Hours"
    case onceADay = "Once a Day"
    case onceAWeek = "Once a Week"
}
