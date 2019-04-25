//
//  PlayViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 3/27/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
//  Responsible for handling the play tab's view controller
import UIKit
import MultipeerConnectivity

class PlayViewController: UIViewController, MCBrowserViewControllerDelegate {

    @IBOutlet weak var narratorButton: UIButton!
    @IBOutlet weak var playerButton: UIButton!
    
    private var mpcManager: MPCManager!
    private var appDelegate: AppDelegate!
    private var narratorPeerID: MCPeerID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        mpcManager = appDelegate.mpcManager!
        CoreGraphicsHelper.colorButtons(button: narratorButton, color: CoreGraphicsHelper.navyBlueColor)
        CoreGraphicsHelper.colorButtons(button: playerButton, color: CoreGraphicsHelper.navyBlueColor)
        mpcManager!.endGame()
    }
    
    @objc func peerDidChangeStateWithNotification(notification: Notification){
        let peerID: MCPeerID = notification.userInfo!["peerID"] as! MCPeerID
        let state: MCSessionState = notification.userInfo!["state"] as! MCSessionState
        print("peerDidChangeStateW/Not called for \(self.mpcManager.peerID.displayName)")
        print("Narrator ID in player browser: \(self.mpcManager.narratorID)")
        print("PeerID: \(peerID)")
        if state == MCSessionState.connected {
            DispatchQueue.main.async {
                if state == MCSessionState.connected && self.mpcManager.narratorID == nil {
                    self.mpcManager.narratorID = peerID
                    self.mpcManager.setupBrowser(shouldBrowse: false)
                    self.performSegue(withIdentifier: "fromPlayToWaitSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func joinGameButtonPressed(_ sender: Any) {
        print("joinGameButtonPressed called")
        if mpcManager.session != nil {
            mpcManager.endGame()
        }
        mpcManager.setupPeerAndSession()
        browseForDevices()
        NotificationCenter.default.addObserver(self, selector: #selector(peerDidChangeStateWithNotification), name: NSNotification.Name("MCDidChangeStateNotification"), object: nil)
    }
    
    
    func browseForDevices(){
        mpcManager.setupBrowser(shouldBrowse: true)
        mpcManager.browser.delegate = self
        self.present(mpcManager.browser, animated: true, completion: nil)
    }
    
    func goToGame() {
        performSegue(withIdentifier: "fromPlayToWaitSegue", sender: self)
    }
    
    // MCBrowserViewDelegate methods
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        NotificationCenter.default.removeObserver(self)
        dismiss(animated: true, completion: goToGame)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        NotificationCenter.default.removeObserver(self)
        self.mpcManager.setupBrowser(shouldBrowse: false)
    }
}
