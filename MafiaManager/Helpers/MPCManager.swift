//
//  MPCManager.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/7/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

class MPCManager: NSObject, MCSessionDelegate {
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant!
    
    override init(){
        self.peerID = nil
        self.session = nil
        self.browser = nil
        self.advertiser = nil
        super.init()
    }
    
    func setupPeerAndSession(){
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession.init(peer: self.peerID)
        self.session.delegate = self
    }
    
    func setupBrowser(shouldBrowse: Bool){
        if shouldBrowse {
            self.browser = MCBrowserViewController.init(serviceType: "mafiamanager-mp", session: self.session)
        } else {
            browser.dismiss(animated: true, completion: nil)
            browser = nil

        }
    }
    
    func advertiseSelf(shouldAdvertise: Bool){
        if shouldAdvertise {
            advertiser = MCAdvertiserAssistant.init(serviceType: "mafiamanager-mp", discoveryInfo: nil, session: self.session)
            advertiser.start()
        } else {
            if (advertiser != nil){
                advertiser.stop()
            }
            advertiser = nil
        }
    }
    
    func removePeer(peerID: MCPeerID){
        sendObject(objData: ["disconnect": "disconnect"], peers: [peerID])
    }
    
    func endGame(){
        sendObject(objData: ["endGame": "endGame"], peers: session.connectedPeers)
        session.disconnect()
    }
    
    func sendObject(objData: [String: Any], peers: [MCPeerID]){
        var data: Data
        do {
             data = try NSKeyedArchiver.archivedData(withRootObject: objData, requiringSecureCoding: false)
            try session.send(data, toPeers: peers, with: MCSessionSendDataMode.reliable)
        } catch {
            
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let dict: [String: Any] = ["peerID": peerID, "state": state]
        NotificationCenter.default.post(name: NSNotification.Name("MCDidChangeStateNotification"), object: nil, userInfo: dict)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        var dataDict: [String: Any] = [:]
        do {
            dataDict = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [String: Any]
        } catch {
            
        }
        let objName: String = dataDict.keys[dataDict.keys.startIndex]
        if objName == "disconnect" {
            session.disconnect()
        } else if objName == "assignStatus" {
        }
        NotificationCenter.default.post(name: NSNotification.Name(objName), object: nil, userInfo: dataDict)

    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
}
