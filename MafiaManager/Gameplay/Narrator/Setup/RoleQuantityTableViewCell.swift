//
//  RoleQuantityTableViewCell.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/7/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

protocol UpdateQuantityDelegate: class {
    func updateQuantity(card: Card, incremented: Bool)
}
class RoleQuantityTableViewCell: UITableViewCell {

    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var card: Card?
    weak var updateQuantityDelegate: UpdateQuantityDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roleLabel.text = card?.cardName
        quantityLabel.text = "0"
        // Initialization code
    }

    @IBAction func decrementQuantityButtonPressed(_ sender: Any) {
        quantityLabel.text = "\(Int(quantityLabel.text!)! - 1)"
        updateQuantityDelegate?.updateQuantity(card: card!, incremented: false)
        
    }
    
    @IBAction func incrementQuantityButtonPressed(_ sender: Any) {
        quantityLabel.text = "\(Int(quantityLabel.text!)! + 1)"
        updateQuantityDelegate?.updateQuantity(card: card!, incremented: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
