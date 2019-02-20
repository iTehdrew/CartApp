import UIKit

protocol ProductListAction: BasePresenter {
    func setEditing(_ editing: Bool)
    func numberOfRows(in section: Int) -> Int
    func object(at indexPath: IndexPath) -> Cart
    func deleteObject(at indexPath: IndexPath)
    func insertObject(at section: Int)
    func incrementQuantity(at indexPath: IndexPath)
    func decrementQuantity(at indexPath: IndexPath)
    var cartProductsAmount: Int { get }
    var totalAmount: Int { get }
    func checkout()
}

final class ProductListPresenter {
    
    // MARK: - Properties
    weak var view: ProductListView!
    private(set) var cart = [Cart]()
    private(set) var products = [Product]()
    
    // MARK: - Init
    func configureView() {
        
        fetchCart()
        fetchProducts()
    }
}

// MARK: - ProductListAction
extension ProductListPresenter: ProductListAction {
    
    var cartProductsAmount: Int {
        return cart.map({ return $0.quantity }).reduce(0, +)
    }
    var totalAmount: Int {
        let amount = cart.map({ return Int($0.product.price)! * $0.quantity }).reduce(0, +)
        return amount
    }
    
    func setEditing(_ editing: Bool) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        view.reloadFooter(at: indexPath.section)
        
        if editing {
            view.removeAddButton()
            view.removeRefreshControl()
        } else {
            view.setupAddButton()
            view.setupRefreshControl()
        }
    }
    
    func fetchCart() {
        guard let url = Bundle.main.url(forResource: "cart", withExtension: "json") else {
            // show error
           return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let cartData = try decoder.decode([Cart].self, from: data)
            print(cartData)
            self.cart = cartData
            view.reloadData()
            view.endRefreshing()
        } catch {
            // show error
            print("error:\(error.localizedDescription)")
        }
    }
    
    func fetchProducts() {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            // show error
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let productData = try decoder.decode([Product].self, from: data)
            print(productData)
            self.products = productData
        } catch {
            // show error
            print("error:\(error.localizedDescription)")
        }
    }
    
    
    func numberOfRows(in section: Int) -> Int {
        cart.isEmpty ? view.setEmptyMessage(NSLocalizedString("cart_empty_label", comment: "")) : view.hideEmptyMessage()
        return cart.count
    }
    
    func object(at indexPath: IndexPath) -> Cart {
        return cart[indexPath.row]
    }
    
    func deleteObject(at indexPath: IndexPath) {
        cart.remove(at: indexPath.row)
        view.deleteRows(at: indexPath)
        view.reloadFooter(at: indexPath.section)
    }
    
    func insertObject(at section: Int) {
        guard let randomObject = products.randomElement().map({ Cart(product: $0, quantity: 1) }) else {
            return
        }
        cart.insert(randomObject, at: 0)
        view.reloadFooter(at: section)
    }
    
    func incrementQuantity(at indexPath: IndexPath) {
        cart[indexPath.row].quantity += 1
        view.reloadRows(at: indexPath)
        view.reloadFooter(at: indexPath.section)
    }
    
    func decrementQuantity(at indexPath: IndexPath) {
        cart[indexPath.row].quantity -= 1
        if cart[indexPath.row].quantity == 0 {
            deleteObject(at: indexPath)
        } else {
            view.reloadRows(at: indexPath)
            view.reloadFooter(at: indexPath.section)
        }
    }
    
    func checkout() {
        let cartProducts = cart.map { $0.product }
        view.showDetails(with: cartProducts)
    }
}
