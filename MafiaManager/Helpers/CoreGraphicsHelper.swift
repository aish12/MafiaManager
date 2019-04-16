//
//  ViewHelper.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/7/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class CoreGraphicsHelper: NSObject {

    static let navyBlueColor = UIColor(red: 0, green: 0.1137, blue: 0.4588, alpha: 1.0)
    static let greenColor = UIColor(red: 0.302, green: 0.757, blue: 0.431, alpha: 1.0)
    static let redColor = UIColor(red: 0.576, green: 0.188, blue: 0.008, alpha: 1.0)
    static let orangeColor = UIColor(red: 0.827, green: 0.725, blue: 0.204, alpha: 1.0)
    static let whiteColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let selectedBorderColor: CGColor = UIColor(red: 0, green: 0.651, blue: 0.9294, alpha: 1.0).cgColor
    static let selectedBorderWidth: CGFloat = 5
    
    static let unselectedBorderColor: CGColor = UIColor.clear.cgColor
    static let unselectedBorderWidth: CGFloat = 0
    
    static let textShadowOpacity: Float = 0.4
    static let textShadowColor: CGColor = UIColor.lightGray.cgColor
    static let textShadowOffset: CGSize = CGSize(width: 3, height: 3)
    static let textShadowRadius: CGFloat = 5
    static let textCornerRadius: CGFloat = 5
    
    enum Class {
        case System
        case Confirm
        case Cancel
        case Warning
    }
    // Takes any imageView and gives it a border of width and color depending on
    // above constants
    static func createSelectedImageBorder(imageView: UIImageView) {
        imageView.layer.borderColor = selectedBorderColor
        imageView.layer.borderWidth = selectedBorderWidth
    }
    
    static func removeSelectedImageBorder(imageView: UIImageView) {
        imageView.layer.borderColor = unselectedBorderColor
        imageView.layer.borderWidth = unselectedBorderWidth
    }
    
    // Shades the text views in deck and card creations/edits/views
    static func shadeTextViews (textView: UITextView) {
        textView.layer.shadowOpacity = textShadowOpacity
        textView.layer.shadowColor = textShadowColor
        textView.layer.shadowOffset = textShadowOffset
        textView.layer.shadowRadius = textShadowRadius
        textView.layer.cornerRadius = textCornerRadius
        textView.layer.masksToBounds = false
    }
    
    static func colorButtons(button: UIButton, color: UIColor) {
        button.backgroundColor = color
        button.layer.cornerRadius = 10
    }
    
    static func styleButton(button: UIButton, buttonClass: Class) {
        switch buttonClass {
        case Class.System:
            button.backgroundColor = navyBlueColor
        case Class.Confirm:
            button.backgroundColor = greenColor
            button.setTitleColor(whiteColor, for: .normal)
        case Class.Warning:
            button.backgroundColor = orangeColor
            button.setTitleColor(whiteColor, for: .normal)
        case Class.Cancel:
            button.backgroundColor = redColor
            button.setTitleColor(whiteColor, for: .normal)
        }
        button.layer.cornerRadius = 10
    }
    
}
