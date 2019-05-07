//
//  SelectDetailViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/6/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit

class SelectDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var deckImageView: UIImageView!
    @IBOutlet weak var deckDetailView: UITextView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    var deck: Deck?
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add background image of wood to collection view
        self.cardCollectionView.backgroundView = UIImageView(image: UIImage(named: "wood1"))
        
        deckImageView.image = UIImage(data: (deck?.deckImage)!)
        deckDetailView.text = deck?.deckDescription
        navBar.topItem!.title = deck?.deckName
        cards = CoreDataHelper.retrieveCards(deck: deck)
        cardCollectionView.reloadData()
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        CoreGraphicsHelper.shadeTextViews(textView: deckDetailView)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetupDeckDetailCell", for: indexPath as IndexPath) as! SetupDeckDetailCell
        let card = cards[indexPath.item]
        cardCell.cardImageView.image = UIImage(data: card.cardImage!)!
        cardCell.cardNameLabel.text = card.cardName
        print(cardCell)
        return cardCell
    }

}
