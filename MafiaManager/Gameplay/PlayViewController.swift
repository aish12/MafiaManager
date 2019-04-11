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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
