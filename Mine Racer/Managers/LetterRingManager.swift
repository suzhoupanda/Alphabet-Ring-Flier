//
//  LetterRingManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class LetterRingManager{
    
    var ringManager = [LetterRing]()
    
    var planeViewController: PlaneViewController!
    
    init(with planeViewController: PlaneViewController) {
        self.planeViewController = planeViewController
    }
    
   
    
    /** Adds a moving ring with a specified letter and letter style to the plane view controller scene **/
    func addRandomizedMovingRing(withLetterStyle letterStyle: LetterStyle, withLetterType letterType: LetterType){
        
        let movingRing = generateRandomizedMovingRingFor(letterStyle: letterStyle, letterType: letterType)
        
        movingRing.addTo(planeViewController: planeViewController)
        
        self.ringManager.append(movingRing)
        
        
    }
    
    
    func addLetterRings(letterRings: [LetterRing]){
        
        letterRings.forEach({
            letterRing in
            
            self.addLetterRing(letterRing: letterRing)
        })
    }
    
    func addLetterRing(letterRing: LetterRing){
        
        letterRing.addTo(planeViewController: planeViewController)
        
        self.ringManager.append(letterRing)
        
    }
    
 
    func generateRandomizedMovingRingFor(letterStyle: LetterStyle, letterType: LetterType) -> LetterRing{
        
        print("Getting randomized moving ring based on player's current position...")
        
        let (xTarget, yTarget, zTarget) = (Int(planeViewController.player.node.position.x),Int(planeViewController.player.node.position.y),Int(planeViewController.player.node.position.z))
        
        print("Getting spawn point...")
        
        let (spawnPointX,spawnPointY,spawnPointZ) = LBPConfiguration.DefaultLBPConfiguration.getRandomSpawnPoint()
        
        let spawnPoint = SCNVector3(xTarget + spawnPointX, yTarget + spawnPointY, zTarget + spawnPointZ)
        
        print("Getting velocity...")
        
        let velocity = SCNVector3(0.0, 0.0,3.0)
        
        print("Getting letter ring node...")
        
        let movingRing = RingCreator.sharedInstance.getMovingRingFor(letterStyle: letterStyle, letterType: letterType, spawnPoint: spawnPoint, velocity: velocity)
        
        
        return movingRing
        
    }
    
    func update(with time: TimeInterval){
        
        ringManager.forEach({
            letterRing in
            
            letterRing.update(with: time)
            
            letterRing.updatePortalNodePosition()
            
            removeExcessNodes()
        })
    }
    
    func removeExcessNodes(){
        
        ringManager.forEach({
            
            letterRing in
            
            if(letterRing.ringNode.position.z > 30){
                letterRing.remove()
            }
        })
    }
    
    
}