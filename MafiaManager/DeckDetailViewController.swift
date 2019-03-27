//
//  DeckDetailViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class DeckDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addCardButtonPressed(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let createAction = UIAlertAction(title: "Create a New Card", style: .default) { (action) in
            self.performSegue(withIdentifier: "fromDetailToNewCardSegue", sender: nil)
        }
        
        let copyAction = UIAlertAction(title: "Copy Existing Card", style: .default) { (action) in
            self.performSegue(withIdentifier: "fromDetailToCopyCardSegue", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(createAction)
        optionMenu.addAction(copyAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
}
