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
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    
    let maxNumForRole = 20
    let minNumForRole = 0
    
    var quantity: Int = 0
    var card: Card?
    weak var updateQuantityDelegate: UpdateQuantityDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roleLabel.text = card?.cardName
        quantityLabel.text = "\(quantity)"
        updateButtons()
    }

    @IBAction func decrementQuantityButtonPressed(_ sender: Any) {
        quantity -= 1
        quantityLabel.text = "\(quantity)"
        updateQuantityDelegate?.updateQuantity(card: card!, incremented: false)
        updateButtons()
    }
    
    @IBAction func incrementQuantityButtonPressed(_ sender: Any) {
        quantity += 1
        quantityLabel.text = "\(quantity)"
        updateQuantityDelegate?.updateQuantity(card: card!, incremented: true)
        updateButtons()
    }
    
    func updateButtons(){
        decrementButton.isEnabled = quantity > minNumForRole
        incrementButton.isEnabled = quantity < maxNumForRole
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
