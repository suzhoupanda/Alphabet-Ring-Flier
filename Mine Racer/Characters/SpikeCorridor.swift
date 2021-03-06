//
//  SpikeCorridor.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/8/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit


class SpikeCorridor{
    
    var detectionNode: SCNNode!
    var mainNode: SCNNode!
    
    var lastUpdateTime: TimeInterval = 0.00
    var frameCount: TimeInterval = 0.00
    var ringExpansionInterval: TimeInterval = 4.00
    
    
    init(spikeTunnelType: EnemyGenerator.SpikeTunnelType, spawnPoint: SCNVector3, velocity: SCNVector3){
        
        self.mainNode = EnemyGenerator.sharedInstance.getSpikeTunnel(of: spikeTunnelType)
        
        self.mainNode.position = spawnPoint
        
        self.mainNode.physicsBody?.velocity = velocity
        
        self.mainNode.opacity = 0.00
        
        configureAuxiliaryGeometries()
    }
    
    init(referenceNode: SCNNode) {
        self.mainNode = referenceNode
        
        self.detectionNode = SCNNode()
        self.detectionNode.opacity = 0.00
        
        /** Configure the Portal Geometry in the middle of the ring **/
        
        configureAuxiliaryGeometries()
    }
    
    func addTo(planeViewController: PlaneViewController){
        
        planeViewController.worldNode.addChildNode(mainNode)
        planeViewController.worldNode.addChildNode(detectionNode)
        
       
        fadeIn()
        
    }
    
    func configureAuxiliaryGeometries(){
        
    }
    
    func remove(){
        mainNode.removeFromParentNode()
        detectionNode.removeFromParentNode()
    }
    
    func setPosition(position: SCNVector3){
        
        self.mainNode.position = position
    }
    
    func setVelocity(velocity: SCNVector3){
        self.mainNode.physicsBody?.velocity = velocity
    }
    
    func fadeIn(){
        self.mainNode.runAction(SCNAction.fadeIn(duration: 2.00))
        
    }
    
    func updatePortalNodePosition(){
        self.detectionNode.position = self.mainNode.presentation.position
    }
    
    func update(with time: TimeInterval){
        
        if(time == 0){
            lastUpdateTime = 0.00
        }
        
        
        frameCount += time - lastUpdateTime
        
        if(frameCount > ringExpansionInterval){
            
            
            SCNTransaction.begin()
            
            SCNTransaction.animationDuration = 2.0
            
            
            SCNTransaction.completionBlock = {
                
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 2.0
                
                
                SCNTransaction.commit()
                
            }
            
            
            SCNTransaction.commit()
            
            frameCount = 0
        }
        
        lastUpdateTime = time
    }
    
}
