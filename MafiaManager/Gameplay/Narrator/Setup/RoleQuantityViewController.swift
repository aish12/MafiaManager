//
//  RoleQuantityViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/7/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class RoleQuantityViewController: UIViewController {

    @IBOutlet weak var peopleNeededLabel: UILabel!
    var deck: Deck?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleNeededLabel.text = "\(deck?.cardForDeck?.count ?? 0) People Needed"
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
