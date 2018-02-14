//
//  PlaneViewController+UI.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit


extension PlaneViewController{
    
    //MARK: ******************** Gameplay Menu Options
    
    /** Helper functions for setting up and manipulating menu buttons that can be used during gameplay **/
    
    func showGameLossMenu(withReason reasonText: String){
        
        self.gameOverMenu = SCNNode()
        
        let reasonButton = getMenuButton(withName: reasonText, andPosition: .upper2)
        self.gameOverMenu.addChildNode(reasonButton)
        
        let restartButton = getMenuButton(withName: "Restart Level", andPosition: .upper1)
        self.gameOverMenu.addChildNode(restartButton)
        
        let backToMainMenu = getMenuButton(withName: "Main Menu", andPosition: .lower1)
        self.gameOverMenu.addChildNode(backToMainMenu)
        
        self.menuNode.addChildNode(self.gameOverMenu)
        self.gameOverMenu.position = MenuPosition.GameOver.getPosition()
        
        worldNode.isPaused = true
        self.scnScene.isPaused = true
        
        AudioManager.sharedInstance.addSound(ofType: .gameLoss, toNode: gameOverMenu, removeAfter: 1.50)
        
        
    }
    
    func showGameWinMenu(){
        
        self.gameWinMenu = SCNNode()
        
        let backToMenuButton = getMenuButton(withName: "Main Menu", andPosition: .upper3)
        self.gameWinMenu.addChildNode(backToMenuButton)
        
        let nextLevelButton = getMenuButton(withName: "Next Level", andPosition: .upper2)
        self.gameWinMenu.addChildNode(nextLevelButton)
        
        
        self.menuNode.addChildNode(self.gameWinMenu)
        self.gameWinMenu.position = MenuPosition.GameWin.getPosition()
        
        worldNode.isPaused = true
        self.scnScene.isPaused = true
        
        AudioManager.sharedInstance.addSound(ofType: .gameWin, toNode: gameWinMenu, removeAfter: 1.50)
    }
    
    
    func setupGamePauseMenu(){
        
        self.pauseMenu = SCNNode()
        
        let restartButton = getMenuButton(withName: "Restart Level", andPosition: .upper1)
        self.pauseMenu.addChildNode(restartButton)
        
        let backToMainMenuButton = getMenuButton(withName: "Main Menu", andPosition: .lower1)
        self.pauseMenu.addChildNode(backToMainMenuButton)
        
        self.menuNode.addChildNode(self.pauseMenu)
        self.pauseMenu.position = MenuPosition.PauseMenu.getPosition()
        
        worldNode.isPaused = true
        self.scnScene.isPaused = true
        
    }
    
    func getMenuButton(withName name: String, andPosition menuPosition: MenuPosition) -> SCNNode{
        
        let text = SCNText(string: name, extrusionDepth: 0.50)
        text.font = UIFont.init(name: "Didot", size: 1.0)
        
        let diffuseMaterial = SCNMaterial()
        diffuseMaterial.diffuse.contents = SKColor.red
        text.materials = [diffuseMaterial]
        
        let button = SCNNode(geometry: text)
        button.name = name
        button.position = menuPosition.getPosition()
        return button
    }
    
    
    func removeGamePauseMenu(){
        if(self.pauseMenu == nil){
            return
        }
        
        self.pauseMenu.removeFromParentNode()
        
        worldNode.isPaused = false
        self.scnScene.isPaused = false
    }
    
    func removeGameOverMenu(){
        if(self.gameOverMenu == nil){
            return
        }
        
        self.gameOverMenu.removeFromParentNode()
    }
    
    func removeGameWinMenu(){
        if(self.gameWinMenu == nil){
            return
        }
        
        self.gameWinMenu.removeFromParentNode()
        
    }
    
    
    func loadMenuNode(){
        
        self.menuNode = SCNNode()
        
        self.pauseText = SCNText(string: "Pause Game", extrusionDepth: 0.1)
        self.pauseText!.chamferRadius = 0.00
        self.pauseText!.font = UIFont.init(name: "Avenir", size: 0.7)
        self.pauseText!.isWrapped = true
        self.pauseText!.alignmentMode = kCAAlignmentLeft
        self.pauseText!.truncationMode = kCATruncationNone
        
        let redCoating = SCNMaterial()
        redCoating.diffuse.contents = SKColor.red
        self.pauseText!.materials = [redCoating]
        
        let pauseButton = SCNNode(geometry: pauseText!)
        
        pauseButton.name = "pauseButton"
        
        self.menuNode.addChildNode(pauseButton)
        
        self.portraitCamera.addChildNode(self.menuNode)
        self.menuNode.position = SCNVector3.init(-0.7, -7.0, -12)
    }
    
    //MARK: ************** Helper Functions for Positioning the Preamble Menus
    
    func positionPlaneColorOptionsMenu(isShowing: Bool){
        
        if(isShowing){
            /** Move menu into position, have each button individually rotate into view **/
            let movePos = SCNVector3(-25.0, -10.0, -42.0)
            self.planeColorMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
            
        } else{
            
            /** Have individual buttons rotate out of view, move men out of position **/
            let movePos = SCNVector3(-25.0, -200.0, -42.0)
            self.planeColorMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
            
        }
    }
    
    func positionGameOptionsMenu(isShowing: Bool){
        
        if(isShowing){
            /** Move menu into position, have each button individually rotate into view **/
            let movePos = SCNVector3(-25.0, -10.0, -42.0)
            self.gameOptionsMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
            
        } else{
            
            /** Have individual buttons rotate out of view, move men out of position **/
            let movePos = SCNVector3(-25.0, -200.0, -42.0)
            self.gameOptionsMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
            
        }
    }
    
    func positionStartMenu(isShowing: Bool){
        
        if(isShowing){
            /** Move menu into position, have each button individually rotate into view **/
            let movePos = SCNVector3(-25.0, 0.0, -42.0)
            self.startMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
            
        } else{
            /** Have individual buttons rotate out of view, move men out of position **/
            let movePos = SCNVector3(-25.0, -200.0, -42.0)
            self.startMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
        }
    }
    
    func positionLevelTracksMenu(isShowing: Bool){
        
        if(isShowing){
            /** Move menu into position, have each button individually rotate into view **/
            let movePos = SCNVector3(-25.0, -10.0, -42.0)
            self.levelTrackMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
            
        } else{
            /** Have individual buttons rotate out of view, move men out of position **/
            let movePos = SCNVector3(-25.0, -200.0, -42.0)
            self.levelTrackMenu.runAction(SCNAction.move(to: movePos, duration: 0.50))
            
        }
    }
    

    
}
