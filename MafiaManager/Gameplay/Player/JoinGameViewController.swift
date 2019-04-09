//
//  JoinGameViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/7/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
import UIKit
import MultipeerConnectivity

class JoinGameViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    private var mpcManager: MPCManager!
    private var appDelegate: AppDelegate!
    
    @IBOutlet weak var availableNarratorsTableView: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        mpcManager = appDelegate.mpcManager!
        mpcManager.setupPeerAndSession()
        mpcManager.advertiseSelf(shouldAdvertise: false)
        browseForDevices()
    }
    
    func browseForDevices(){
        mpcManager.setupBrowser(shouldBrowse: true)
        mpcManager.browser.delegate = self
        self.present(mpcManager.browser, animated: true, completion: nil)
    }
    
    func goToGame() {
        performSegue(withIdentifier: "fromJoinToWaitSegue", sender: self)
    }
    
    func returnToPlayView() {
        mpcManager.setupBrowser(shouldBrowse: false)
        // Dismiss does not pop current VC correctly; use this instead
        self.navigationController?.popViewController(animated: true)
    }
    
    // MCBrowserViewDelegate methods
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: goToGame)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        print("browser cancelled!")
        dismiss(animated: true, completion: returnToPlayView)
    }
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "fromJoinToWaitSegue", sender: self)
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
