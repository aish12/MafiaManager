//
//  CoreDataHelper.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/18/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    static func addDeck(newName: String, newDescription: String, newImage: Data) -> Deck {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let deck = Deck(context: context)

        deck.deckName = newName
        deck.deckDescription = newDescription
        deck.deckImage = newImage
        
        saveCoreData(context: context)
        
        return deck
    }
    
    static func addCard(deck: Deck, newName: String, newDescription: String, newImage: Data) -> Card {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let card = Card(context: context)

        card.cardName = newName
        card.cardDescription = newDescription
        card.cardImage = newImage
        card.deckForCard = deck
        
        saveCoreData(context: context)
        
        return card
    }
    
    static func editDeck(deck: Deck, newName: String, newDescription: String, newImage: Data){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        deck.deckName = newName
        deck.deckDescription = newDescription
        deck.deckImage = newImage
        
        saveCoreData(context: context)
    }
    
    static func editCard(card: Card, newName: String, newDescription: String, newImage: Data){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        card.cardName = newName
        card.cardDescription = newDescription
        card.cardImage = newImage
        
        saveCoreData(context: context)
    }
    
    static func removeDeck(deck: Deck){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let cardsInDeck: [Card]? = Array(deck.cardForDeck!) as? [Card]
        
        context.delete(deck)
        
        if cardsInDeck != nil {
            for card in cardsInDeck! {
                context.delete(card)
            }
        }
        saveCoreData(context: context)
    }
    
    static func removeCard(card: Card){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(card)
        
        saveCoreData(context: context)
    }
    
    static func saveCoreData(context: NSManagedObjectContext){
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    static func retrieveDecks() -> [Deck] {
        return retrieveEntity(entity: "Deck", predicate: nil) as! [Deck]
    }
    
    static func retrieveCards(deck: Deck?) -> [Card] {
        if deck != nil {
            let predicate = NSPredicate(format: "deckForCard == %@", deck!)
            return retrieveEntity(entity: "Card", predicate: predicate) as! [Card]
        } else {
            return retrieveEntity(entity: "Card", predicate: nil) as! [Card]
        }
    }
    
    static func retrieveEntity(entity: String, predicate: NSPredicate?) -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        if predicate != nil {
            request.predicate = predicate
        }
        do {
            let entities = try context.fetch(request) as? [NSManagedObject]
            return entities!
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    static func clearAllData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let requestDeck = NSFetchRequest<NSFetchRequestResult>(entityName:
            "Deck")
        var fetchedDecks:[NSManagedObject]
        
        do {
            try fetchedDecks = context.fetch(requestDeck) as! [NSManagedObject]
           
            if fetchedDecks.count > 0 {
                
                for result:AnyObject in fetchedDecks {
                    context.delete(result as! NSManagedObject)
                }
            }
            try context.save()
        
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        let requestCards = NSFetchRequest<NSFetchRequestResult>(entityName:
            "Card")
        var fetchedCards:[NSManagedObject]
        
        do {
            try fetchedCards = context.fetch(requestCards) as! [NSManagedObject]
            print(fetchedCards)
            
            if fetchedCards.count > 0 {
                
                for result:AnyObject in fetchedCards {
                    context.delete(result as! NSManagedObject)
                }
            }
            try context.save()
            
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}
