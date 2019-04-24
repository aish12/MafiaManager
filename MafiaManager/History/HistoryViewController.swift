//
//  HistoryViewController.swift
//  MafiaManager
//
//  Created by Aishwarya Shashidhar on 3/24/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Dummy for now, responsible for handling the history tab view controller (stretch goal)
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    class GameHistory {
        var deck : Deck?
        var narrator: String?
        var winner: String?
        var date:Date
        init(_date: Date, _deck: Deck, _narrator: String, _winner: String) {
            date = _date
            deck = _deck
            narrator = _narrator
            winner = _winner
        }
    }

    @IBOutlet weak var historyTableView: UITableView!
    var games: [GameHistory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let decks = CoreDataHelper.retrieveDecks()
        let dates = [Date(), Date(), Date(), Date(), Date()]
        let narratorNames = ["Robby", "Tesia", "Daniel", "Aish", "Bob"]
        let winnerNames = ["Robby", "Robby", "Tesia", "Tesia", "Tesia"]
        for i in 0...4 {
            games.append(GameHistory(_date: dates[i], _deck: decks[i % decks.count], _narrator: narratorNames[i], _winner: winnerNames[i]))
        }
        historyTableView.delegate = self
        historyTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy" //yyyy
        return formatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyTableResultsCell", for: indexPath as IndexPath) as! HistoryTableViewCell
        let gameHistoryItem = games[indexPath.item]
        //cell.date = gameHistoryItem.date
        cell.dateLabel.text = stringFromDate(gameHistoryItem.date )
        //cell.deck = gameHistoryItem.deck
        //cell.narrator = gameHistoryItem.narrator
        //cell.winner = gameHistoryItem.winner
        cell.deckLabel.text = gameHistoryItem.deck?.deckName
        cell.narratorLabel.text = gameHistoryItem.narrator
        cell.winnerLabel.text = gameHistoryItem.winner
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromHistoryViewToHistoryDetail" {
            let destinationVC = segue.destination as! HistoryGameDetailViewController
            
            let funcIndex = historyTableView.indexPathForSelectedRow?.row
            destinationVC.winnerName = games[funcIndex!].winner
            destinationVC.deckName = games[funcIndex!].deck?.deckName
        }
    }
}
