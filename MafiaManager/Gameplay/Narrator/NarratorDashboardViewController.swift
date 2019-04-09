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
    var connectedDevices: [MCPeerID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        narratorTableView.delegate = self
        narratorTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectedDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = narratorTableView.dequeueReusableCell(withIdentifier: "narratorTableCell", for: indexPath as IndexPath)
        cell.textLabel!.text = connectedDevices[indexPath.item].displayName
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
    
}
