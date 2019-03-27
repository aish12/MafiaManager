//
//  DecksViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 3/24/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Manages the Decks View Controller

import UIKit

class DecksViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var newDeckButton: UIButton!
    let deckCellIdentifier = "DeckCell"
    let addDeckCellIdentifier = "AddDeckCell"
    
    // Dummy to be completed, required for collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // Dummy to be completed, required for collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: addDeckCellIdentifier, for: indexPath as IndexPath)
            return addCell
            
        } else {
            let deckCell = collectionView.dequeueReusableCell(withReuseIdentifier: deckCellIdentifier, for: indexPath as IndexPath)
            return deckCell
        }
    }
    
    // On load, round the corners of any buttons to standard size (10)
    override func viewDidLoad() {
        super.viewDidLoad()
        newDeckButton.layer.cornerRadius = 10
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
