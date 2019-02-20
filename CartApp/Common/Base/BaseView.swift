import UIKit

protocol BaseView: AnyObject {
    func open(module: BaseModule)
}

extension BaseView where Self: UIViewController {

    func open(module: BaseModule) {
        if let navigation = navigationController {
            navigation.pushViewController(module.viewController(), animated: true)
        }
    }
}
