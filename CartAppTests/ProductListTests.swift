@testable import CartApp
import XCTest

final class ProductListTests: XCTestCase {

    private var module: ProductListModule!
    
    override func setUp() {
        super.setUp()
        
        module = ProductListModule()
        module.view.loadViewIfNeeded()
    }
    
    func testIsConfirmToDataSourceAndDelegate() {
        XCTAssertNotNil(module.view as UITableViewDataSource)
        XCTAssertNotNil(module.view as UITableViewDelegate)
    }
    
    func testFetchCart() {
        module.presenter.fetchCart()
        
        XCTAssertFalse(module.presenter.cart.isEmpty)
    }
    
    func testFetchProducts() {
        module.presenter.fetchProducts()
        
        XCTAssertFalse(module.presenter.products.isEmpty)
    }
    
    func testCartfetching() {
        guard let url = Bundle.main.url(forResource: "cart", withExtension: "json") else {
            XCTFail()
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = try? Data(contentsOf: url)
        XCTAssertNotNil(data)
        
        let cartData = try? decoder.decode([Cart].self, from: data!)
        XCTAssertNotNil(cartData)
    }
    
    func testProductsfetching() {
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            XCTFail()
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = try? Data(contentsOf: url)
        XCTAssertNotNil(data)
        
        let cartData = try? decoder.decode([Product].self, from: data!)
        XCTAssertNotNil(cartData)
    }
    
    func testEmptyState() {
        module.view.setEmptyMessage("test_message")
        XCTAssertNotNil(module.view.tableView.backgroundView)
        
        module.view.hideEmptyMessage()
        XCTAssertNil(module.view.tableView.backgroundView)
    }
    
    func testNumberOfRows() {
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertEqual(module.presenter.cart.count,
                       module.presenter.numberOfRows(in: indexPath.section))
    }
    
    func testDeleteObject() {
        let indexPath = IndexPath(row: 0, section: 0)
        let currentObjectCount = module.presenter.cart.count
        module.presenter.deleteObject(at: indexPath)
        XCTAssertEqual(module.presenter.cart.count,
                       currentObjectCount - 1)
    }
    
    func testInsertObject() {
        let indexPath = IndexPath(row: 0, section: 0)
        let currentObjectCount = module.presenter.cart.count
        module.presenter.insertObject(at: indexPath.section)
        XCTAssertEqual(module.presenter.cart.count,
                       currentObjectCount + 1)
    }
    
    func testIncrementQuantity() {
        let indexPath = IndexPath(row: 0, section: 0)
        let currentProductCount = module.presenter.cart[indexPath.row].quantity
        module.presenter.incrementQuantity(at: indexPath)
        XCTAssertEqual(module.presenter.cart[indexPath.item].quantity,
                       currentProductCount + 1)
    }
    
    func testDecrementQuantity() {
        let indexPath = IndexPath(row: 0, section: 0)
        let currentProductCount = module.presenter.cart[indexPath.row].quantity
        let currentObjectCount = module.presenter.cart.count
        module.presenter.decrementQuantity(at: indexPath)
        
        if currentProductCount == 1 {
            XCTAssertEqual(module.presenter.cart.count,
                           currentObjectCount - 1)
        } else {
            XCTAssertEqual(module.presenter.cart[indexPath.row].quantity,
                           currentProductCount - 1)
        }
    }
    
    func testEditing() {
        module.presenter.setEditing(true)
        XCTAssertNil(module.view.navigationItem.leftBarButtonItem)
        XCTAssertNil(module.view.refreshControl)
        
        module.presenter.setEditing(false)
        XCTAssertNotNil(module.view.navigationItem.leftBarButtonItem)
        XCTAssertNotNil(module.view.refreshControl)
    }
    
    func testEndRefreshing() {
        module.view.refreshControl?.beginRefreshing()
        XCTAssertNotNil(module.view.refreshControl)
        XCTAssertTrue(module.view.refreshControl!.isRefreshing)
        
        module.view.endRefreshing()
        XCTAssertFalse(module.view.refreshControl!.isRefreshing)
    }

    func testSetupRefreshControl() {
        if module.view.refreshControl != nil {
            module.view.removeRefreshControl()
        }
        XCTAssertNil(module.view.refreshControl)
        
        module.view.setupRefreshControl()
        XCTAssertNotNil(module.view.refreshControl)
        let refreshControls = module.view.tableView.subviews.filter({ $0 is UIRefreshControl })
        XCTAssertFalse(refreshControls.isEmpty)
    }
}
