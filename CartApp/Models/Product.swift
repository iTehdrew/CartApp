import UIKit

struct Product: Decodable {
    let id: Int
    let title: String
    let price: String
    private let oldPrice: String?
    let image: String
    var attributedOldPrice: NSAttributedString? {
        guard let oldPrice = oldPrice,
            let oldPriceNumber = Int(oldPrice),
            let formattedOldPrice = NumberFormatter.usMoneyFormatWithSeparator().string(from: NSNumber(value: oldPriceNumber)) else {
                return nil
        }
        
        return NSAttributedString(string: formattedOldPrice,
                                  attributes:[.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                                              .strikethroughStyle: 1.0])
    }
}
