//
//  PlayViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/27/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var narratorButton: UIButton!
    @IBOutlet weak var playerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        narratorButton.layer.cornerRadius = 10
        playerButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
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
