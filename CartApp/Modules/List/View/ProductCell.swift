import UIKit

protocol ProductCellDelegate: AnyObject {
    func didTapIncrementQuantity(_ cell: ProductCell)
    func didTapDecrementQuantity(_ cell: ProductCell)
}

final class ProductCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var oldPriceLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var quantityLabel: UILabel!
    @IBOutlet private var quantityView: UIView!
    @IBOutlet private var quantityContainerView: UIView!
    
    // MARK: - Properties
    static let height: CGFloat = 140.0
    weak var delegate: ProductCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        quantityView.layer.borderWidth = 1
        quantityView.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
        quantityView.layer.cornerRadius = 3.0
        quantityContainerView.layer.borderWidth = 1
        quantityContainerView.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
    }

    func configure(with product: Product, quantity: Int) {
        titleLabel.text = product.title
        oldPriceLabel.attributedText = product.attributedOldPrice
        oldPriceLabel.isHidden = product.attributedOldPrice == nil
        priceLabel.text = NumberFormatter.usMoneyFormatWithSeparator().string(from: NSNumber(value: Int(product.price) ?? 0))
        quantityLabel.text = String(quantity)
        iconImageView.setImage(from: product.image)
    }
}

// MARK: - Actions
private extension ProductCell {
    
    @IBAction func incrementQuantity(_ sender: UIButton) {
        delegate?.didTapIncrementQuantity(self)
    }
    
    @IBAction func decrementQuantity(_ sender: UIButton) {
        delegate?.didTapDecrementQuantity(self)
    }
}
