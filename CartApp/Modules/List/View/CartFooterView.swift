//
//  CartView.swift
//  RozetkaTest
//
//  Created by Andrew Konovalskyi on 2/20/19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

protocol CartFooterViewDelegate: AnyObject {
    func didTapCheckout(_ view: CartFooterView)
}

final class CartFooterView: UITableViewHeaderFooterView {

    // MARK - IBOutlet
    @IBOutlet private var totalLabel: UILabel!
    @IBOutlet private var checkoutButton: UIButton!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var productsWorthLabel: UILabel!
    
    // MARK: - Properties
    static let height: CGFloat = 170.0
    weak var delegate: CartFooterViewDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        checkoutButton.layer.cornerRadius = 3.0
    }
    
    func configure(amount: Int, totalProducts: Int) {
        amountLabel.text = NumberFormatter.usMoneyFormatWithSeparator().string(from: NSNumber(value: amount))
        productsWorthLabel.text = String(format: NSLocalizedString("cart_products_worth_label", comment: ""), String(totalProducts))
        totalLabel.text = NSLocalizedString("cart_total_label", comment: "")
        checkoutButton.setTitle(NSLocalizedString("cart_checkout_button", comment: ""), for: .normal)
    }
}

// MARK: - Actions
private extension CartFooterView {
    
    @IBAction func checkout(_ sender: UIButton) {
        delegate?.didTapCheckout(self)
    }
}
