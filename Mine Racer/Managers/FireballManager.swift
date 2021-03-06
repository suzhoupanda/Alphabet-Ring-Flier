//
//  FireballManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/10/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class FireballManager{
    
    
    
    var fireballManager = [SCNNode]()
    
    var planeViewController: PlaneViewController!
    
    init(with planeViewController: PlaneViewController) {
        self.planeViewController = planeViewController
    }
    
    /** Adds a moving ring with a specified letter and letter style to the plane view controller scene; the velocity and spawn point are randomized based on a hard-coded configuration object  **/
    
    
    func addRandomFireballs(number: Int){
        
        if(number <= 0){
            return
        }
        
        for _ in 1...number{
            let randomVelocityType = VelocityType.getDefaultVelocityType()
            
            switch randomVelocityType{
            case .HighVelocityNHNW:
                addHighVelocityNHNWFireball()
                break
            case .HighVelocityLHLW:
                addHighVelocityLHLWFireball()
                break
            case .LowVelocityLHLW:
                addLowVelocityLHLWFireball()
                break
            case .LowVelocityNHNW:
                addLowVelocityNHNWFireball()
                break
            }
        }
    }
    
    
    func addLowVelocityLHLWFireball(){
        
        let fireBall = generateLowVelocityLHLWFireball()
        
        addFireball(fireBall: fireBall)
    
        
    }
    
    func addLowVelocityNHNWFireball(){
        
        let fireBall = generateLowVelocityNHNWFireball()
        
        addFireball(fireBall: fireBall)
    }
    
    
    func addHighVelocityNHNWFireball(){
        
        let fireBall = generateHighVelocityNHNWFireball()
        
        addFireball(fireBall: fireBall)
    }
    
    func addHighVelocityLHLWFireball(){
        
        let fireBall = generateHighVelocityLHLWFireball()
        
        addFireball(fireBall: fireBall)
    }
    
    
    /** Helper functions for adding spacecraft individually and in bulk, without configuring the velocity or spawn point **/
    
    func addFireballGroup(fireballs: [SCNNode]){
        
        fireballs.forEach({
            fireball in
       
            self.addFireball(fireBall: fireball)
        })
    }
    
    func addFireball(fireBall: SCNNode){
        
        fireBall.opacity = 0.00
        
       planeViewController.worldNode.addChildNode(fireBall)
        
        
        fireBall.runAction(SCNAction.fadeIn(duration: 0.50))
        
        fireBall.removeAfterTime(waitTime: 2.00)
        
        fireballManager.append(fireBall)
        
    }
    
    
    
    /** Generates a moving spacecraft whose spawn point and velocity are randomized based on a hard-coded default configuration object **/
    
    func generateLowVelocityLHLWFireball() -> SCNNode{
        
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.HighVelocityNHNWFireBall)
    }
    
    func generateLowVelocityNHNWFireball() -> SCNNode{
        
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.HighVelocityNHNWFireBall)
    }
    
    
    func generateHighVelocityLHLWFireball() -> SCNNode{
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.HighVelocityNHNWFireBall)

    }
    
    func generateHighVelocityNHNWFireball() -> SCNNode{
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.HighVelocityNHNWFireBall)
    }
    
    func generateDefaultRandomizedFireball() -> SCNNode{
        
        return generateRandomizedFireballFor(withLBPConfiguration: LBPConfiguration.HighVelocityNHNWFireBall)
        
    }
    
    /** Generates a moving spacecraft whose spawn point is randomized based on a configuration object whose parameters are user-defined **/
    
    
    func generateRandomizedFireballFor(withLBPConfiguration configuration: LBPConfiguration) -> SCNNode{
        
        
        let (xTarget, yTarget, zTarget) = (Int(planeViewController.player.node.presentation.position.x),Int(planeViewController.player.node.presentation.position.y),Int(planeViewController.player.node.presentation.position.z))
        
        let (spawnPointX,spawnPointY,spawnPointZ) = configuration.getRandomSpawnPoint()
        
        let spawnPoint = SCNVector3(xTarget + spawnPointX, yTarget + spawnPointY, zTarget + spawnPointZ)
        
        print("Spawn point is x: \(spawnPoint.x), y: \(spawnPoint.y), z: \(spawnPoint.z)")
        
        let velocity = configuration.getRandomVelocityVector()
        
        
        let fireball = EnemyGenerator.sharedInstance.getFireBall()
        
        fireball.configureWithEnemyPhysicsProperties()
        
        fireball.physicsBody?.velocity = velocity
        fireball.position = spawnPoint
        
        return fireball
        
    }
    
    
    func update(with time: TimeInterval){
        
        removeExcessNodes()
    }
    
    /** Remove fireballs after they pass the player **/
    
    func removeExcessNodes(){
        
        fireballManager.forEach({
            
            fireball in
            
            if(fireball.position.z >= 0){
                fireball.removeFromParentNode()
                print("Fireballs removed...number of fireballs remaining is ... \(fireballManager.count)")
            }
        })
    }
    
    
}

