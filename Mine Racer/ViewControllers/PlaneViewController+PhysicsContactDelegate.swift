//
//  PlaneViewController+PhysicsContactDelegate.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit


extension PlaneViewController: SCNPhysicsContactDelegate{
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        
        var contactNode: SCNNode!
        
        if contact.nodeA.name == "player"{
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        
        
        if lastContactNode != nil && lastContactNode == contactNode{
            return
        }
        
        switch UInt32(contactNode.physicsBody!.categoryBitMask){
        case CollisionMask.PortalCenter.rawValue:
            if let letterName = contactNode.name,let contactLetter = letterName.last, let nextLetter = self.tempWord?.first{
                if contactLetter == nextLetter{
                    
                    AudioManager.sharedInstance.addSound(ofType: .acquireLetter, toNode: self.player.node, removeAfter: 1.00)
                    
                    self.tempWord?.removeFirst()
                    self.wordInProgress!.append(contactLetter)
                    print("The current word is \(self.wordInProgress!)")
                    self.hud.updateHUD()
                    
                    
                    
                }
                
            }
            
            
            break
        case CollisionMask.DetectionNode.rawValue:
            print("Player has been detected by the space craft")
            print("The contactNode name is \(contactNode.name!)")
            if(contactNode.name != nil && (contactNode.name!.contains("SpaceCraft") || contactNode.name!.contains("Turret"))){
                print("Sending notificaiton...")
                NotificationCenter.default.post(name: Notification.WasDetectedBySpaceCraftNotification, object: self, userInfo: [
                    "nodeName":contactNode.name!
                    ])
            }
            break
        case CollisionMask.Bullet.rawValue:
            print("Player has been hit by a bullet")
            
            player.takeDamage(by: 1)
            hud.updateHUD()
            
            print("Current player's health is: \(self.player.health)")
            break
        case CollisionMask.Enemy.rawValue:
            print("Player has been hit by an enemy")
            player.takeDamage(by: 1)
            hud.updateHUD()
            
            print("Current player's health is: \(self.player.health)")
            break
        case CollisionMask.Obstacle.rawValue:
            print("Player has been hit by obstacle")
            player.takeDamage(by: 1)
            hud.updateHUD()
            
            print("Current player's health is: \(self.player.health)")
            break
        default:
            print("No contact logic implemented, contactNode info - category mask: \(contactNode.physicsBody!.categoryBitMask), contact mask: \(contactNode.physicsBody!.contactTestBitMask)")
        }
        
        //TODO: implement contact logic here
        
        lastContactNode = contactNode
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        
    }
    
    
}

