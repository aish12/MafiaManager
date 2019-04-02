//
//  Deck.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/2/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Represents a user's custom deck. Is comprised of a title, description,
//  and an array of card objects

import UIKit

class Deck: NSObject {
    
    private var deckName: String
    private var deckDescription: String
    private var deckImage: UIImage
    private var deckCards: [Card]
    
    init(name: String, description: String, image: UIImage) {
        self.deckName = name
        self.deckDescription = description
        self.deckImage = image
        self.deckCards = []
    }
    
    func getDeckName() -> String {
        return self.deckName
    }
    
    func getDeckDescription() -> String {
        return self.deckDescription
    }
    
    func getDeckImage() -> UIImage {
        return self.deckImage
    }
    
    func getDeckCards() -> [Card] {
        return self.deckCards
    }
    
    func setDeckName(newName: String) {
        self.deckName = newName
    }
    
    func setDeckDescription(newDescription: String) {
        self.deckDescription = newDescription
    }
    
    func setDeckImage(newImage: UIImage) {
        self.deckImage = newImage
    }
    
    func addCard(newCard: Card){
        self.deckCards.append(newCard)
    }
    

}
