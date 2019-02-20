import UIKit

protocol ProductListView: BaseView {
    func setupAddButton()
    func removeAddButton()
    func setupRefreshControl()
    func removeRefreshControl()
    func reloadData()
    func reloadFooter(at section: Int)
    func reloadRows(at indexPath: IndexPath)
    func deleteRows(at indexPath: IndexPath)
    func endRefreshing()
    func showDetails(with products: [Product])
    func setEmptyMessage(_ message: String)
    func hideEmptyMessage()
}

final class ProductListViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private(set) var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: ProductListAction!
    private(set) var refreshControl: UIRefreshControl?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productNib = UINib(nibName: String(describing: ProductCell.self), bundle: nil)
        tableView.register(productNib,
                           forCellReuseIdentifier: String(describing: ProductCell.self))
        let footerNib = UINib(nibName: String(describing: CartFooterView.self), bundle: nil)
        tableView.register(footerNib,
                           forHeaderFooterViewReuseIdentifier: String(describing: CartFooterView.self))
        
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = editButtonItem
        setupAddButton()
        setupRefreshControl()
        
        title = NSLocalizedString("cart_title", comment: "")
        presenter.configureView()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        presenter.setEditing(editing)
    }
}

// MARK: - Actions
private extension ProductListViewController {
    
    @IBAction func refreshData(_ refreshControl: UIRefreshControl) {
        presenter.configureView()
    }
    
    @IBAction func insertNewObject(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.insertObject(at: indexPath.section)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - View logic
extension ProductListViewController: ProductListView {
    
    func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.leftBarButtonItem = addButton
    }
    
    func removeAddButton() {
        navigationItem.leftBarButtonItem = nil
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        tableView.addSubview(refreshControl)
        self.refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    func removeRefreshControl() {
        refreshControl?.removeTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl?.removeFromSuperview()
        refreshControl = nil
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func reloadRows(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func reloadFooter(at section: Int) {
        guard let footer = tableView.footerView(forSection: section) as? CartFooterView else {
            return
        }
        if tableView.isEditing || presenter.numberOfRows(in: section) == 0 {
            footer.isHidden = true
        } else {
            footer.isHidden = false
        }
        footer.configure(amount: presenter.totalAmount, totalProducts: presenter.cartProductsAmount)
    }
    
    func deleteRows(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func endRefreshing() {
        refreshControl?.endRefreshing()
    }
    
    func showDetails(with products: [Product]) {
        open(module: ProductDetailsModule(products: products))
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: tableView.center.x,
                                                 y: tableView.center.y,
                                                 width: tableView.bounds.size.width,
                                                 height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel;
    }
    
    func hideEmptyMessage() {
        tableView.backgroundView = nil
    }
}

// MARK: - UITableViewDataSource
extension ProductListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductCell.self),
                                                       for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        let object = presenter.object(at: indexPath)
        cell.configure(with: object.product, quantity: object.quantity)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            String(describing: CartFooterView.self)) as? CartFooterView else {
                return nil
        }
        footer.isHidden = tableView.isEditing
        footer.configure(amount: presenter.totalAmount, totalProducts: presenter.cartProductsAmount)
        footer.delegate = self
        return footer
    }
}

// MARK: - UITableViewDelegate
extension ProductListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return tableView.isEditing ? .delete : .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            presenter.deleteObject(at: indexPath)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProductCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CartFooterView.height
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - ProductCellDelegate
extension ProductListViewController: ProductCellDelegate {
    
    func didTapIncrementQuantity(_ cell: ProductCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        presenter.incrementQuantity(at: indexPath)
    }
    
    func didTapDecrementQuantity(_ cell: ProductCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        presenter.decrementQuantity(at: indexPath)
    }
}

// MARK: - CartFooterViewDelegate
extension ProductListViewController: CartFooterViewDelegate {
    
    func didTapCheckout(_ view: CartFooterView) {
        presenter.checkout()
    }
}
