//
//  PlaneViewController+TouchesBegan.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/21/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit


extension PlaneViewController{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        let location = touch.location(in: scnView)
        
        let hitResults = scnView.hitTest(location, options: nil)
        
        if let node = hitResults.first?.node{
            
            if(gameHelper.state == .GameOver){
                
                print("Inside touchesBegain, gamOver touch handlers....")
                
                if(node.name == nil){
                    return
                }
                
                
                switch node.name!{
                case "Main Menu":
                    print("Proceeding back to main menu...")
                    returnToMainMenu()
                    break
                case "Next Level":
                    loadNextLevel()
                    break
                case "Restart Level":
                    restartCurrentLevel()
                    break
                default:
                    break
                }
                
            }
            
            
            if(gameHelper.state == .TapToPlay){
                
                if(node.name == nil){
                    return
                }
                
                switch node.name!{
                case "StartGame":
                    positionStartMenu(isShowing: false)
                    loadGame()
                    break
                case "GameOptions":
                    positionGameOptionsMenu(isShowing: true)
                    positionStartMenu(isShowing: false)
                    break
                case "LevelTracks":
                    positionLevelTracksMenu(isShowing: true)
                    positionStartMenu(isShowing: false)
                    break
                case "PlaneColors":
                    positionPlaneColorOptionsMenu(isShowing: true)
                    positionStartMenu(isShowing: false)
                    break
                case "Red":
                    gameHelper.planeType = .red
                    positionPlaneColorOptionsMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                case "Blue":
                    gameHelper.planeType = .blue
                    positionPlaneColorOptionsMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                case "Yellow":
                    gameHelper.planeType = .yellow
                    positionPlaneColorOptionsMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                case "Hard":
                    gameHelper.difficulty = .Hard
                    positionGameOptionsMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                case "Medium":
                    gameHelper.difficulty = .Medium
                    positionGameOptionsMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                case "Easy":
                    gameHelper.difficulty = .Easy
                    positionGameOptionsMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                case "SpaceShips":
                    gameHelper.levelTrack = .SpaceShips
                    positionLevelTracksMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                case "SpikeBalls":
                    gameHelper.levelTrack = .SpikeBalls
                    positionLevelTracksMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                case "FireBalls":
                    gameHelper.levelTrack = .FireBalls
                    positionLevelTracksMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                case "AlienHeads":
                    gameHelper.levelTrack = .AlienHeads
                    positionLevelTracksMenu(isShowing: false)
                    positionStartMenu(isShowing: true)
                    break
                default:
                    print("No logic implemented for this node")
                    break
                    
                }
                
            }
            
            if(gameHelper.state == .Playing){
                
                if(node.name == nil){
                    return
                }
                
                if node.name == "pauseButton"{
                    
                    if(self.scnScene.isPaused){
                        self.pauseText!.string = "Pause Game"
                        self.removeGamePauseMenu()
                    } else{
                        self.pauseText!.string = "Resume Game"
                        self.setupGamePauseMenu()
                    }
                    
                    
                    print("Game has been paused")
                    return
                }
                
                
                switch node.name!{
                case "Restart Level":
                    restartCurrentLevel()
                    break
                case "Main Menu":
                    returnToMainMenu()
                    break
                default:
                    break
                    
                }
                
                if(node.name == "biplane_blue"){
                    print("Touched the plane, will jjump button")
                }
            }
            
        }
    }
    
    
}
