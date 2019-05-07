//
//  DeckSelectionViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/6/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData

class DeckSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating,UIPopoverPresentationControllerDelegate {
    
    
    var decks: [Deck] = []
    var deckToShowDetail: Deck?
    let deckSelectReuseIdentifier: String = "DeckSelectCell"
    var deckSearchController = UISearchController(searchResultsController: nil)
    var filteredDecks: [Deck] = []
    var selectedDeck: Deck?
    @IBOutlet weak var decksCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add background image of wood to collection view
        self.decksCollectionView.backgroundView = UIImageView(image: UIImage(named: "wood1"))
        
        nextButton.isEnabled = false
        decksCollectionView.dataSource = self
        decksCollectionView.delegate = self
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.decksCollectionView.addGestureRecognizer(longPressGR)
        loadDecks()
        
        deckSearchController.searchResultsUpdater = self
        deckSearchController.obscuresBackgroundDuringPresentation = false
        deckSearchController.searchBar.placeholder = "Search Decks"
        navigationItem.searchController = deckSearchController
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        loadDecks()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredDecks.count
        }
        return decks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deckSelectReuseIdentifier, for: indexPath as IndexPath) as! DeckSelectionCollectionViewCell
        var deck: Deck!
        if isFiltering() {
            deck = filteredDecks[indexPath.item]
        } else {
            deck = decks[indexPath.item]
        }
        cell.deckLabel.text = deck.value(forKey: "deckName") as? String
        cell.deckImageView.image = UIImage(data: deck.value(forKey: "deckImage") as! Data)
        cell.deckImageView.layer.cornerRadius = 10
        cell.deckImageView.layer.masksToBounds = true
    
        if selectedDeck == deck {
            CoreGraphicsHelper.createSelectedImageBorder(imageView: cell.deckImageView)
        } else {
            CoreGraphicsHelper.removeSelectedImageBorder(imageView: cell.deckImageView)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        decksCollectionView.deselectItem(at: indexPath, animated: true)
        nextButton.isEnabled = true
        var selectedDeck: Deck!
        if isFiltering() {
            selectedDeck = filteredDecks[indexPath.item]
        } else {
            selectedDeck = decks[indexPath.item]
        }
        if self.selectedDeck == selectedDeck {
            self.selectedDeck = nil
        } else {
            self.selectedDeck = selectedDeck
        }
        decksCollectionView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func isFiltering() -> Bool {
        return deckSearchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return deckSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDecks = decks.filter({( deck : Deck) -> Bool in
            return deck.deckName!.lowercased().contains(searchText.lowercased())
        })
        
        decksCollectionView.reloadData()
    }
    
    // Retrieves the decks data from core data and reloads the Collection View's data with this
    func loadDecks() {
        decks = CoreDataHelper.retrieveDecks()
        let selectedCell: IndexPath? = decksCollectionView.indexPathsForSelectedItems!.count > 0 ? decksCollectionView.indexPathsForSelectedItems![0] : nil
        decksCollectionView.reloadData()
        if selectedCell != nil {
            decksCollectionView.selectItem(at: selectedCell!, animated: true, scrollPosition: [])
        }
    }
    
    // Long press for each collection view cell
    @objc func handleLongPress(longPressGR : UILongPressGestureRecognizer) {
        if longPressGR.state != .began {
            return
        }
        let point = longPressGR.location(in: self.decksCollectionView)
        let indexPath = self.decksCollectionView.indexPathForItem(at: point)
        if let indexPath = indexPath {
            deckToShowDetail = decks[indexPath.item]
            performSegue(withIdentifier: "fromDeckSelectToDeckDetail", sender: self)
        } else {
            print("Could not find indexPath")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDeckSelectToDeckDetail" {
            if let destinationVC = segue.destination as? SelectDetailViewController {
                destinationVC.popoverPresentationController?.sourceRect = CGRect(x:-self.view.bounds.width, y:-self.view.bounds.height, width: self.view.bounds.width - 20, height: self.view.bounds.height - 30)
                destinationVC.deck = deckToShowDetail
                destinationVC.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
                destinationVC.modalPresentationStyle = .popover
                destinationVC.popoverPresentationController?.delegate = self
            }
        } else if segue.identifier == "fromDeckSelectToRoleQuantity" {
            if let destinationVC = segue.destination as? RoleQuantityViewController {
                destinationVC.deck = selectedDeck
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
