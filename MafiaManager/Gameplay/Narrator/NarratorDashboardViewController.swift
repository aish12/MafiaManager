//
//  NarratorDashboardViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/26/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the narrator's dashboard view controller

import UIKit
import MultipeerConnectivity

class NarratorDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var narratorTableView: UITableView!
    var cardPlayer = [Dictionary<String, Card>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        narratorTableView.delegate = self
        narratorTableView.dataSource = self
        narratorTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardPlayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = narratorTableView.dequeueReusableCell(withIdentifier: "narratorTableCell", for: indexPath as IndexPath) as! NarratorDashboardTableViewCell
        cell.playerName = cardPlayer[indexPath.item].keys.first
        cell.playerNameLabel.text = cell.playerName

        let card = cardPlayer[indexPath.item].values.first
        cell.roleLabel.text = card?.cardName
        // TODO: change to a variable for now
        cell.playerStatusLabel.text = "Alive"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        narratorTableView.deselectRow(at: indexPath, animated: true)
        // the "row"th note
        let row = indexPath.row
        print(row)
    }

    
    // If the narrator decides to end the game, display a confirmation
    // If they choose yes, segue to the record winners screen, if no, stay on dashboard
    @IBAction func endGameButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Ending a game cannot be undone", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.performSegue(withIdentifier: "fromDashboardToRecordSegue", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromNarratorDashboardCellToPlayerCard" {
            let destinationVC = segue.destination as! NarratorChangeRoleViewController
            
            let funcIndex = narratorTableView.indexPathForSelectedRow?.row
            let card = cardPlayer[funcIndex!].values.first
            destinationVC.name = card?.cardName
            //destinationVC.playerDescription.text = card?.cardDescription
            //destinationVC.playerImageView.image = UIImage(data: (card?.cardImage)!)
            // TODO: do status logic
            //destinationVC.playerStatus.text = "Alive"
        }
    }
}
