//
//  DeckCellCollectionViewCell.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/2/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Handles the decksCollectionView cells

import UIKit

protocol DeleteDeckDelegate: class {
    func deleteDeck(cellIndex: Int)
}
class DeckCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deckCellImageView: UIImageView!
    weak var delegate: DeleteDeckDelegate?
    var deleteButton: UIButton!
    var deleteButtonImg: UIImage!
    var cellIndex: Int!
    
    // If not already in edit mode, add the x icon and a wiggle to the cell to show it is editable
    func enterEditMode() {
        if deleteButton?.superview == nil {
            deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width/4, height: frame.size.width/4))
            
            deleteButtonImg = UIImage(named: "deleteIcon")!.withRenderingMode(.alwaysTemplate)
            deleteButton.setImage(deleteButtonImg, for: .normal)
            deleteButton.tintColor = UIColor.red
            deleteButton.addTarget(self, action: #selector(deleteDeck), for: .touchUpInside)
            deleteButton.tag = 100
            print("Adding x subview")
            contentView.addSubview(deleteButton)
            startWiggle()
        }
    }
    
    // If in edit mode, remove the x icon from the superview and stop the wiggle animation
    func leaveEditMode() {
        if deleteButton?.superview != nil{
            deleteButton.removeFromSuperview()
        }
        stopWiggle()
    }
    
    // Called when the x icon is pressed in edit mode, begins process to delete deck in DecksViewController
    @objc func deleteDeck() {
        delegate?.deleteDeck(cellIndex: cellIndex)
    }
    
    // Helper functino to animate wiggle
    private func degreesToRadians(_ x: CGFloat) -> CGFloat {
        return .pi * x / 180.0
    }
    
    // Adds position and transform animations to the cell to give it an editable style
    // Similar to the iOS homescreen. Credit to ajgryc @ https://stackoverflow.com/questions/6604356/ios-icon-jiggle-algorithm/53771810#53771810
    func startWiggle(
        duration: Double = 0.25,
        displacement: CGFloat = 1.0,
        degreesRotation: CGFloat = 2.0
        ) {
        print("wiggle called")
        let negativeDisplacement = -1.0 * displacement
        let position = CAKeyframeAnimation.init(keyPath: "position")
        position.beginTime = 0.8
        position.duration = duration
        position.values = [
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement)),
            NSValue(cgPoint: CGPoint(x: 0, y: 0)),
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: 0)),
            NSValue(cgPoint: CGPoint(x: 0, y: negativeDisplacement)),
            NSValue(cgPoint: CGPoint(x: negativeDisplacement, y: negativeDisplacement))
        ]
        position.calculationMode = CAAnimationCalculationMode(rawValue: "linear")
        position.isRemovedOnCompletion = false
        position.repeatCount = Float.greatestFiniteMagnitude
        position.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))
        position.isAdditive = true
        
        let transform = CAKeyframeAnimation.init(keyPath: "transform")
        transform.beginTime = 2.6
        transform.duration = duration
        transform.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateZ)
        transform.values = [
            degreesToRadians(-1.0 * degreesRotation),
            degreesToRadians(degreesRotation),
            degreesToRadians(-1.0 * degreesRotation)
        ]
        transform.calculationMode = CAAnimationCalculationMode(rawValue: "linear")
        transform.isRemovedOnCompletion = false
        transform.repeatCount = Float.greatestFiniteMagnitude
        transform.isAdditive = true
        transform.beginTime = CFTimeInterval(Float(arc4random()).truncatingRemainder(dividingBy: Float(25)) / Float(100))
        
        self.layer.add(position, forKey: nil)
        self.layer.add(transform, forKey: nil)
    }
    
    // Removes wiggle animations from cells and returns them to original position
    func stopWiggle(){
        self.layer.removeAllAnimations()
        self.transform = CGAffineTransform.identity
    }
}
