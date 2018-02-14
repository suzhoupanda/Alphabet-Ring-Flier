//
//  AudioManager.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/18/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

class AudioManager{
    
    static let sharedInstance = AudioManager()
    
    enum SoundType{
        case gameWin,gameLoss,acquireLetter,gameStart,planeHit,engine1,engine2,engine3,engine4
    }
    
    var planeHitSounds = [SCNAudioSource]()
    var gameWinSounds = [SCNAudioSource]()
    var gameLossSounds = [SCNAudioSource]()
    var acquireLetterSounds = [SCNAudioSource]()
    var gameStartSounds = [SCNAudioSource]()
    
    var engine1Sound: SCNAudioSource!
    var engine2Sound: SCNAudioSource!
    var engine3Sound: SCNAudioSource!
    var engine4Sound: SCNAudioSource!
    var engine5Sound: SCNAudioSource!
    
    private init() {
        loadSounds()
        
      
    }
    
    
    func getAudioSource(ofType soundType: SoundType) -> SCNAudioSource?{
        
        var gameAudioSrc: SCNAudioSource?
        
        switch soundType{
        case .acquireLetter:
            gameAudioSrc = acquireLetterSounds.getRandomElement() as? SCNAudioSource
            break
        case .gameLoss:
            gameAudioSrc = gameLossSounds.getRandomElement() as? SCNAudioSource
            break
        case .gameWin:
            gameAudioSrc = gameWinSounds.getRandomElement() as? SCNAudioSource
            break
        case .gameStart:
            gameAudioSrc = gameStartSounds.getRandomElement() as? SCNAudioSource
            break
        case .planeHit:
            gameAudioSrc = planeHitSounds.getRandomElement() as? SCNAudioSource
            break
        case .engine1:
            gameAudioSrc = self.engine1Sound
            break
        case .engine2:
            gameAudioSrc = self.engine2Sound
            break
        case .engine3:
            gameAudioSrc = self.engine3Sound
            break
        case .engine4:
            gameAudioSrc = self.engine4Sound
            break
        }
        
        return gameAudioSrc
    }
    
    func addSound(ofType soundType: SoundType, toNode gameNode: SCNNode, removeAfter numberSeconds: Double?){
        
        /**
        if(gameWinSounds.isEmpty || gameWinSounds.count <= 0){
            return
        }
        
        if(gameLossSounds.isEmpty || gameLossSounds.count <= 0){
            return
        }
        
        if(planeHitSounds.isEmpty || planeHitSounds.count <= 0){
            return
        }
        
        if(acquireLetterSounds.isEmpty || acquireLetterSounds.count <= 0){
            return
        }
        
        if(gameStartSounds.isEmpty || gameStartSounds.count <= 0){
            return
        }
        
        if(engine1Sound == nil || engine2Sound == nil || engine3Sound == nil || engine4Sound == nil || engine5Sound == nil){
            return
        }
         **/
            
            var gameAudioSrc: SCNAudioSource?
            
            switch soundType{
            case .acquireLetter:
                gameAudioSrc = acquireLetterSounds.getRandomElement() as? SCNAudioSource
                break
            case .gameLoss:
                gameAudioSrc = gameLossSounds.getRandomElement() as? SCNAudioSource
                break
            case .gameWin:
                gameAudioSrc = gameWinSounds.getRandomElement() as? SCNAudioSource
                break
            case .gameStart:
                gameAudioSrc = gameStartSounds.getRandomElement() as? SCNAudioSource
                break
            case .planeHit:
                gameAudioSrc = planeHitSounds.getRandomElement() as? SCNAudioSource
                break
            case .engine1:
                gameAudioSrc = self.engine1Sound
                break
            case .engine2:
                gameAudioSrc = self.engine2Sound
                break
            case .engine3:
                gameAudioSrc = self.engine3Sound
                break
            case .engine4:
                gameAudioSrc = self.engine4Sound
                break
            }
            
            guard let audioSrc = gameAudioSrc else {
                print("Error: failed to obtain requested audio src")
                return
            }
            
            let audioPlayer = SCNAudioPlayer(source: audioSrc)
            gameNode.addAudioPlayer(audioPlayer)
        
            if let seconds = numberSeconds{
                
                gameNode.runAction(SCNAction.sequence([
                    SCNAction.wait(duration: TimeInterval(seconds)),
                    SCNAction.run({_ in
                        gameNode.removeAudioPlayer(audioPlayer)
                    })
                    ]))
            }
        
    }
    
    private func loadSounds(){
        loadPlaneHitSound(withFileName: "hitHelmet1.wav")
        loadPlaneHitSound(withFileName: "hitHelmet2.wav")
        loadPlaneHitSound(withFileName: "hitHelmet3.wav")
        loadPlaneHitSound(withFileName: "hitHelmet4.wav")
        loadPlaneHitSound(withFileName: "hitHelmet5.wav")
        
        loadGameWinSound(withFileName: "you_win.wav")
        loadGameWinSound(withFileName: "objective_achieved.wav")
        
        loadGameLoseSound(withFileName: "you_lose.wav")
        
        loadGameStartSound(withFileName: "prepare_yourself.wav")
        
        loadAcquireLetterSound(withFileName: "jump1.wav")

    }
    
    private func loadEngine1Sound(){
        if let sound = SCNAudioSource(fileNamed: "engine1.wav"){
            self.engine1Sound = sound
        }
    }
    
    private func loadEngine2Sound(){
        if let sound = SCNAudioSource(fileNamed: "engine2.wav"){
            self.engine2Sound = sound
        }
    }
    
    private func loadEngine3Sound(){
        if let sound = SCNAudioSource(fileNamed: "engine3.wav"){
            self.engine3Sound = sound
            
        }
    }
    
    private func loadEngine4Sound(){
        if let sound = SCNAudioSource(fileNamed: "engine4.wav"){
            self.engine4Sound = sound
        }
    }
    
    
    private func loadAcquireLetterSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            planeHitSounds.append(sound)
        }
    }
    
    private func loadGameStartSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            gameStartSounds.append(sound)
        }
    }
    
    private func loadGameLoseSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            gameLossSounds.append(sound)
        }
    }
    
    private func loadGameWinSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            gameWinSounds.append(sound)
        }
    }
    
    private func loadPlaneHitSound(withFileName fileName: String){
        if let sound = SCNAudioSource(fileNamed: fileName){
            planeHitSounds.append(sound)
        }
        
    }
}
