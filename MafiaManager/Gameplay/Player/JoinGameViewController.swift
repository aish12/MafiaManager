//
//  JoinGameViewController.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/7/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//
import UIKit
import MultipeerConnectivity
import Firebase

class JoinGameViewController: UIViewController, MCBrowserViewControllerDelegate {
    

    @IBOutlet weak var availableNarratorsTableView: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    private var mpcManager: MPCManager!
    private var appDelegate: AppDelegate!
    private var narratorPeerID: MCPeerID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        mpcManager = appDelegate.mpcManager!
        if mpcManager.session != nil {
            mpcManager.endGame()
        }
        mpcManager.setupPeerAndSession()
        browseForDevices()
        NotificationCenter.default.addObserver(self, selector: #selector(peerDidChangeStateWithNotification), name: NSNotification.Name("MCDidChangeStateNotification"), object: nil)
    }
    
    @objc func peerDidChangeStateWithNotification(notification: Notification){
        let peerID: MCPeerID = notification.userInfo!["peerID"] as! MCPeerID
        let state: MCSessionState = notification.userInfo!["state"] as! MCSessionState
        print("Narrator ID in player browser: \(self.mpcManager.narratorID)")
        print("PeerID: \(peerID)")
        if state == MCSessionState.connected {
            DispatchQueue.main.async {
                if state == MCSessionState.connected && self.mpcManager.narratorID == nil {
                    self.mpcManager.narratorID = peerID
                    self.mpcManager.setupBrowser(shouldBrowse: false)
                    //SEND MESSAGE TO NARRATOR WITH USER ID
                    print("sending narrator message")
                    self.mpcManager.sendObject(objData: ["PeerGaveID": ["peerID": self.mpcManager.peerID, "uid": Auth.auth().currentUser!.uid]], peers: [peerID])
//                    self.performSegue(withIdentifier: "fromJoinToWaitSegue", sender: self)
                }
            }
        }
    }

    func browseForDevices(){
        mpcManager.setupBrowser(shouldBrowse: true)
        mpcManager.browser.delegate = self
        self.present(mpcManager.browser, animated: true, completion: nil)
    }
    
    func goToGame() {
//        performSegue(withIdentifier: "fromJoinToWaitSegue", sender: self)
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
        dismiss(animated: true, completion: returnToPlayView)
    }
}
