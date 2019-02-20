import UIKit

final class ProductDetailsModule: BaseModule {
    
    private let view: ProductDetailsViewController
    private let presenter: ProductDetailsPresenter
    
    init(products: [Product]) {
        view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ProductDetailsViewController.self)) as! ProductDetailsViewController
        presenter = ProductDetailsPresenter(products: products)
        presenter.view = view
        view.presenter = presenter
    }
    
    func viewController() -> UIViewController {
        return view
    }
}

