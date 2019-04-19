//
//  PlayerSession.swift
//  MafiaManager
//
//  Created by Robert Stigler on 4/15/19.
//  Copyright © 2019 Aishwarya Shashidhar. All rights reserved.
//

import UIKit
import MultipeerConnectivity

struct PlayerSession {
    var playerID: MCPeerID
    var card: Card!
    var isAlive: Bool!
    var isWinner: Bool!
    
    init(playerID: MCPeerID, card: Card, isAlive: Bool){
        self.playerID = playerID
        self.card = card
        self.isAlive = isAlive
        self.isWinner = false
    }
    
    init(playerID: MCPeerID, card: Card){
        self.playerID = playerID
        self.card = card
        self.isAlive = true
        self.isWinner = false
    }
    
    init(playerID: MCPeerID){
        self.playerID = playerID
        self.card = nil
        self.isAlive = true
        self.isWinner = false
    }
}
