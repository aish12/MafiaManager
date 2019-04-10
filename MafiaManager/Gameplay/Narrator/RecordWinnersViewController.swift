//
//  RecordWinnersViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the record winner's view controller

import UIKit

class RecordWinnersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var cardPlayer : [Dictionary<String, Card>]?
    var playerStatuses : [String]?
    @IBOutlet weak var recordResultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordResultsTableView.delegate = self
        recordResultsTableView.dataSource = self
        recordResultsTableView.reloadData()
    }
    
    // If they do not want to record winners, return back to play tab screen
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // If they have recorded winners, return back to play tab screen
    @IBAction func recordResultsButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cardPlayer?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordResultsTableView.dequeueReusableCell(withIdentifier: "recordResultsTableCell", for: indexPath as IndexPath) as! RecordWinnerTableViewCell
        cell.playerName = cardPlayer![indexPath.item].keys.first
        cell.playerNameLabel.text = cell.playerName
        
        let card = cardPlayer![indexPath.item].values.first
        cell.roleLabel.text = card?.cardName
        // TODO: change to a variable for now
        cell.playerStatusLabel.text = playerStatuses![indexPath.item]
        
        return cell
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
