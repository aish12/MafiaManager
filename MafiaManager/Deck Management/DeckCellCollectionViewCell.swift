//
//  DeckCellCollectionViewCell.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/2/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class DeckCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deckCellImageView: UIImageView!
    var deleteButton: UIButton!
    var deleteButtonImg: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width/4, height: frame.size.width/4))
            
            deleteButtonImg = UIImage(named: "deleteIcon")!.withRenderingMode(.alwaysTemplate)
            deleteButton.setImage(deleteButtonImg, for: .normal)
            deleteButton.tintColor = UIColor.red
            
            contentView.addSubview(deleteButton)
    }
}
