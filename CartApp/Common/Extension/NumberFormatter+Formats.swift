import UIKit

extension NumberFormatter {
    
    static func usMoneyFormatWithSeparator(minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 0) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "uk-UA")
        formatter.currencySymbol = "грн"
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter
    }
}
