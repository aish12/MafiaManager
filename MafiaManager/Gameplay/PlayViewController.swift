//
//  PlayViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/27/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the play tab's view controller
import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var narratorButton: UIButton!
    @IBOutlet weak var playerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreGraphicsHelper.colorButtons(button: narratorButton, color: CoreGraphicsHelper.navyBlueColor)
        CoreGraphicsHelper.colorButtons(button: playerButton, color: CoreGraphicsHelper.navyBlueColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let mpcManager = (UIApplication.shared.delegate as? AppDelegate)!.mpcManager
        mpcManager!.endGame()
    }
}
