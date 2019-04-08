//
//  SelectDetailViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/6/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class SelectDetailViewController: UIViewController {

    @IBOutlet weak var deckImageView: UIImageView!
    @IBOutlet weak var deckDetailView: UITextView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var deck: Deck?
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(deck)
        deckImageView.image = UIImage(data: (deck?.deckImage)!)
        deckDetailView.text = deck?.deckDescription
        navBar.topItem!.title = deck?.deckName
        
        CoreGraphicsHelper.shadeTextViews(textView: deckDetailView)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("in here")
        dismiss(animated: true, completion: nil)
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
