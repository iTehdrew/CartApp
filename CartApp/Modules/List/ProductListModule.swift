import UIKit

final class ProductListModule: BaseModule {
    
    let view: ProductListViewController
    let presenter: ProductListPresenter
    
    init() {
        view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ProductListViewController.self)) as! ProductListViewController
        presenter = ProductListPresenter()
        presenter.view = view
        view.presenter = presenter
    }
    
    func viewController() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
}
