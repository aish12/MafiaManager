//
//  DeckSelectionViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/6/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData

class DeckSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate {
    
    var deckObjects: [Deck] = []
    var deckToShowDetail: Deck?
    let deckSelectReuseIdentifier: String = "DeckSelectCell"
    @IBOutlet weak var decksCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        decksCollectionView.dataSource = self
        decksCollectionView.delegate = self
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGR:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.decksCollectionView.addGestureRecognizer(longPressGR)
        loadDecks()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)
        loadDecks()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deckObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deckSelectReuseIdentifier, for: indexPath as IndexPath) as! DeckSelectionCollectionViewCell
        let deck = deckObjects[indexPath.item]
        cell.deckLabel.text = deck.value(forKey: "deckName") as? String
        cell.deckImageView.image = UIImage(data: deck.value(forKey: "deckImage") as! Data)
        cell.deckImageView.layer.cornerRadius = 10
        cell.deckImageView.layer.masksToBounds = true
        let selectedCells = decksCollectionView.indexPathsForSelectedItems
        if selectedCells!.count > 0, selectedCells![0] == indexPath {
            CoreGraphicsHelper.createSelectedImageBorder(imageView: cell.deckImageView)
        } else {
            CoreGraphicsHelper.removeSelectedImageBorder(imageView: cell.deckImageView)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nextButton.isEnabled = true
        let selectedCell = decksCollectionView.cellForItem(at: indexPath) as! DeckSelectionCollectionViewCell
        CoreGraphicsHelper.createSelectedImageBorder(imageView: selectedCell.deckImageView)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let selectedCell = decksCollectionView.cellForItem(at: indexPath) as! DeckSelectionCollectionViewCell
        let selectedArr = decksCollectionView.indexPathsForSelectedItems
        if (selectedArr?.count)! > 0, indexPath == selectedArr![0] {
            nextButton.isEnabled = false
            CoreGraphicsHelper.removeSelectedImageBorder(imageView: selectedCell.deckImageView)
            decksCollectionView.deselectItem(at: indexPath, animated: true)
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let selectedCell = decksCollectionView.cellForItem(at: indexPath) as! DeckSelectionCollectionViewCell
        CoreGraphicsHelper.removeSelectedImageBorder(imageView: selectedCell.deckImageView)
    }
    
    // Retrieves the decks data from core data and reloads the Collection View's data with this
    func loadDecks() {
        deckObjects = CoreDataHelper.retrieveDecks()
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
            deckToShowDetail = deckObjects[indexPath.item]
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
                let deck: Deck = deckObjects[decksCollectionView.indexPathsForSelectedItems![0].item]
                destinationVC.deck = deck
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

}
