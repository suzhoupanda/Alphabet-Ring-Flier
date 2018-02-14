//
//  PlaneViewController+SceneRendererDelegate.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit


extension PlaneViewController: SCNSceneRendererDelegate{
        
        
        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            
            if(time == 0){
                lastUpdatedTime = 0
            }
            
            
            if(gameHelper.state == .Playing){
                
                if(self.scnScene.isPaused || self.worldNode.isPaused){
                    return
                }
                
                if(player.health <= 0){
                    
                    self.gameHelper.state = .GameOver
                    self.worldNode.runAction(completion: {
                        self.showGameLossMenu(withReason: "Out of Lives!")
                        
                    }, afterTime: 1.00)
                    
                    
                }
                
                if let wordInProgress = self.wordInProgress, let currentWord = self.currentWord{
                    
                    if(wordInProgress == currentWord){
                        
                        self.worldNode.runAction(completion: {
                            self.gameHelper.state = .GameOver
                            self.showGameWinMenu()
                            
                        }, afterTime: 1.00)
                        
                        
                        
                    }
                }
                
                
                letterRingManager.update(with: time)
                spaceCraftManager.update(with: time)
                fireballManager.update(with: time)
                alienHeadManager.update(with: time)
                
                cleanExcessNodes()
                
                updateCameraPositions()
                
            }
            
            lastUpdatedTime = time
            
        }
        
        func cleanExcessNodes(){
            
            for node in worldNode.childNodes{
                if node.position.z > 30{
                    node.removeFromParentNode()
                }
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
            
            
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
            
            
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didApplyConstraintsAtTime time: TimeInterval) {
            
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
            
        }
        
        func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
            
        }
        
        
}


