//
//  NarratorChangeRoleViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/9/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class NarratorChangeRoleViewController: UIViewController {

    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerName: UITextView!
    @IBOutlet weak var playerStatus: UILabel!
    @IBOutlet weak var playerDescription: UITextView!
    
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerName.text = name
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
