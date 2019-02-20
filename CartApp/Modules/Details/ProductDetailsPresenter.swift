import UIKit

protocol ProductDetailsAction: BasePresenter {
    
}

final class ProductDetailsPresenter: ProductDetailsAction {
    
    weak var view: ProductDetailsView!
    var products: [Product]
    
    init(products: [Product]) {
        self.products = products
    }
    
    func configureView() {
        let productsList = self.products.map{ $0.title }.joined(separator: ", ")
        let text = String(format: NSLocalizedString("details_description", comment: ""), productsList)
        view.setupView(with: text)
    }
}
