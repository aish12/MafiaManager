//
//  CardViewController.swift
//  MafiaManager
//
//  Created by Tesia Wu on 4/5/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData

class CardViewController: UIViewController {

    var cardObject: NSManagedObject = NSManagedObject()
    @IBOutlet weak var cardName: UITextView!
    @IBOutlet weak var cardDescription: UITextView!
    @IBOutlet weak var cardImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cardName.text = cardObject.value(forKey: "cardName") as? String
        self.cardDescription.text = cardObject.value(forKey: "cardDescription") as? String
        self.cardImage.image = UIImage(data: cardObject.value(forKey: "cardImage") as! Data)
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
