//
//  DecksViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 3/24/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class DecksViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let deckCellIdentifier = "DeckCell"
    let addDeckCellIdentifier = "AddDeckCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: addDeckCellIdentifier, for: indexPath as IndexPath)
            addCell.textLabel?.text = "Add"
            addCell.contentView.text
            return addCell
            
        } else {
            let deckCell = collectionView.dequeueReusableCell(withReuseIdentifier: deckCellIdentifier, for: indexPath as IndexPath)
            deckCell.textLabel?.text = "Deck \(indexPath.row)"
            return deckCell
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
