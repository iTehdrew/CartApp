import UIKit

protocol ProductDetailsView: BaseView {
    func setupView(with text: String)
}

final class ProductDetailsViewController: UIViewController {
    
    @IBOutlet private var productsLabel: UILabel!
    
    // MARK: - Properties
    var presenter: ProductDetailsAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("details_title", comment: "")
        presenter.configureView()
    }
}

// MARK: - View logic
extension ProductDetailsViewController: ProductDetailsView {
    
    func setupView(with text: String) {
        productsLabel.text = text
    }
}
