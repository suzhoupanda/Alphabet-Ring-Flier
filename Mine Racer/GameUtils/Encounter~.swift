//
//  Encounter.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/7/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import GameplayKit



class EncounterSeries{
    
    var firstEncounter: Encounter
    var planeViewController: PlaneViewController
    
    var hasTerminatedEncounterSeries: Bool = false
    
    var currentEncounter: Encounter?{
        didSet{
            
            print("Current encounter has been set, executing nextencounter.....")

            if(currentEncounter != nil){
                executeEncounter()
            }
        }
    }
    
    /**
    func showEncounterSeriesInformation(){
        print("The total wait time for this encounter is: \(totalSeriesTime)")
    }
    **/
    
    func showFirstEncounterInformation(){
    
            let (waitTime, fireballs,turrets,spaceCraft,spikeBalls,letters) = (
                firstEncounter.waitTime,
                firstEncounter.numberOfFireballs ?? 0,
                firstEncounter.numberOfAlienHeads ?? 0,
                firstEncounter.numberOfSpaceCraft ?? 0,
                firstEncounter.numberOfSpikeBalls ?? 0,
                firstEncounter.numberOfLetters ?? 0)
        
        print("The wait time for this encounter is \(waitTime) seconds, and the number of turrets is \(turrets), the number of spacecraft is \(spaceCraft), the number of spikeballs is \(spikeBalls), the number of fireballs is \(fireballs), the number of letters is \(letters)")
    }
    
    @objc func terminateEncounterSeries(){
        print("Notification received by EncounterSeries....requesting restart")
        self.hasTerminatedEncounterSeries = true
    }
    
    /**
    var totalSeriesTime: Double{
        return getEncounterTime()
    }

    var numberOfEncounters: Int{
        return getNumberOfEncounters(runningTotal: &nil, currentEncounter: nil)
    }
    **/

    //MARK: ******* NOT YET IMPLEMENTED
    
    /**
     func getNumberOfEncounters(runningTotal: inout Int?, currentEncounter: Encounter?) -> Int{
        

        if(runningTotal == nil){
            runningTotal = 0
        }
        
        if(currentEncounter == nil && self.firstEncounter == nil){
            
            runningTotal = 0
            
        } else if(currentEncounter == nil && self.firstEncounter != nil && self.firstEncounter.nextEncounter == nil) {
            
            runningTotal! += 1
            
        } else if(currentEncounter == nil && self.firstEncounter != nil && self.firstEncounter.nextEncounter != nil){
            
        }else if(currentEncounter != nil && self.currentEncounter?.nextEncounter == nil) {
           
            runningTotal! += 1
         
        } else if(currentEncounter != nil && self.currentEncounter?.nextEncounter != nil){
            
            runningTotal! += 1
            getNumberOfEncounters(runningTotal: &runningTotal, currentEncounter: currentEncounter!.nextEncounter!)
            
        }
        
        return runningTotal!
    }
 
 **/
    
    
    /**

    private func getEncounterTime(withEncounter encounter: Encounter? = nil) -> Double{
        
        let currentEncounter = encounter ?? self.firstEncounter
        
        var time = currentEncounter.waitTime
        
        if let nextEncounter = self.currentEncounter?.getNextEncounter(){
            
            time += getEncounterTime(withEncounter: nextEncounter)
            
        } else {
            return time
        }
        
        /** Return statement will never be executed, only provided to satisfy compiler **/
        return 0.00
    }
    **/
    
    /**
    private func getTotalLettersGenerated() -> Int{
        
        var numberOfLetters = self.firstEncounter.numberOfLetters ?? 0
        
        if let nextEncounter = self.firstEncounter.getNextEncounter(){
            numberOfLetters += nextEncounter.numberOfLetters ?? 0
            
            return getTotalLettersGenerated()
        } else {
            return numberOfLetters
        }
    }
 
    **/
    
    init(planeViewController: PlaneViewController, firstEncounter: Encounter) {
        self.firstEncounter = firstEncounter
        self.planeViewController = planeViewController
        
   
        
    }
    
    

    
    func start(){
        print("Starting the encounter series....setting the first encounter...")
        self.currentEncounter = self.firstEncounter
    }
    
    
    
    func executeEncounter(){
    
        if(GameHelper.sharedInstance.state != .Playing || hasTerminatedEncounterSeries){
            return
        }
        
        if(self.currentEncounter == nil){
            return
        }
        
        let waitTime = self.currentEncounter!.waitTime
        
        print("Preparing to execute next encounter....")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + waitTime, execute: {
            
            if(GameHelper.sharedInstance.state != .Playing || self.hasTerminatedEncounterSeries){
                return
            }
            
            print("Adding game objects for encounter....")

            self.addGameObjects()
            
            
            print("Getting next encounter....")

            if let nextEncounter = self.currentEncounter!.getNextEncounter(){
                
                print("Setting next encounter....")

                self.currentEncounter = nextEncounter
        
            } else {
                print("No more encounters in series...")
                self.planeViewController.encounterIsFinished = true
            }
            
        })
    }
    
    private func addGameObjects(){
        
        
        if(GameHelper.sharedInstance.state != .Playing || self.planeViewController.scnScene.isPaused || self.planeViewController.worldNode.isPaused){
            return
        }
        
        if let numberOfSpikeBalls = self.currentEncounter!.numberOfSpikeBalls{
            planeViewController.spikeBallManager.addRandomSpikeBalls(number: numberOfSpikeBalls)
        }
        
        if let numberOfSpaceCraft = self.currentEncounter!.numberOfSpaceCraft{
            planeViewController.spaceCraftManager.addRandomSpaceCraft(number: numberOfSpaceCraft)
        }
        
        if let numberOfLetters = self.currentEncounter!.numberOfLetters{
            
            planeViewController.letterRingManager.addRandomizedMovingRing(with: numberOfLetters, fromWord: planeViewController.currentWord)
        }
        
        if let numberOfFireballs = self.currentEncounter!.numberOfFireballs{
            planeViewController.fireballManager.addRandomFireballs(number: numberOfFireballs)
        }
        
        if let numberOfAlienHeads = self.currentEncounter!.numberOfAlienHeads{
            planeViewController.alienHeadManager.addRandomAlienHeads(number: numberOfAlienHeads)
        }
        
    }
}


extension EncounterSeries{
    
    
    static func GenerateEncounterSeries(forPlaneViewController planeViewController: PlaneViewController, forLevelTrack levelTrack: GameHelper.LevelTrack, andforLevel level: Int) -> EncounterSeries{
        
        switch level {
            
            /** Get encounter series for fireball track  **/
        case 0...3 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 200, withMaxFireballs: level+10, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 50, withMaxFireballs: level+5, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0, withMaxAlienHeads: 0, withMaxWaitTime: 4)
        case 8...11 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 3, withNumberOfEncounters: 25, withMaxFireballs: level, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 4)
        case 12...15 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 25, withMaxFireballs: level-2, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 3)
        case 16...30 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 25, withMaxFireballs: level-5, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 3)
        case 31...10000 where levelTrack == .FireBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 20, withMaxFireballs: level-5, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 3)

            
            /** Get encounter series for spaceship track  **/

        case 0...3 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 5, withNumberOfEncounters: 150, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level+9,withMaxAlienHeads: 0, withMaxWaitTime: 3)
        case 4...7 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 50, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level+10,withMaxAlienHeads: 0, withMaxWaitTime: 4)
        case 8...11 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level+5,withMaxAlienHeads: 0, withMaxWaitTime: 3)
        case 12...15 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxAlienHeads: 0, withMaxWaitTime: 2)
        case 16...30 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxAlienHeads: 0, withMaxWaitTime: 2)
        case 31...10000 where levelTrack == .SpaceShips:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 2, withNumberOfEncounters: 20, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: level,withMaxAlienHeads: 0, withMaxWaitTime: 2)

            
            /** Get encounter series for spikeball track  **/

        case 0...3 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: level+9, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 50, withMaxFireballs: 0, withMaxSpikeBalls: level+5, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 5)
        case 8...11 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 5)
        case 12...15 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 5)
        case 16...30 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 5)
        case 31...10000 where levelTrack == .SpikeBalls:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 20, withMaxFireballs: 0, withMaxSpikeBalls: level, withMaxSpaceCraft: 0,withMaxAlienHeads: 0, withMaxWaitTime: 5)

        
            /** Get encounter series for turret track  **/

        case 0...3 where levelTrack == .AlienHeads:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 100, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: level+6, withMaxWaitTime: 5)
        case 4...7 where levelTrack == .AlienHeads:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 6, withNumberOfEncounters: 50, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: level+5, withMaxWaitTime: 5)
        case 8...11 where levelTrack == .AlienHeads:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: level, withMaxWaitTime: 5)
        case 12...15 where levelTrack == .AlienHeads:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: level, withMaxWaitTime: 5)
        case 16...30 where levelTrack == .AlienHeads:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: level, withMaxWaitTime: 5)
        case 31...10000 where levelTrack == .AlienHeads:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 4, withNumberOfEncounters: 25, withMaxFireballs: 0, withMaxSpikeBalls: 0, withMaxSpaceCraft: 0,withMaxAlienHeads: level, withMaxWaitTime: 5)
        default:
            return EncounterSeries.GenerateEncounterSeries(forPlaneViewController: planeViewController, withMaxLetter: 3, withNumberOfEncounters: 25, withMaxFireballs: 2, withMaxSpikeBalls: 2, withMaxSpaceCraft: 2,withMaxAlienHeads: level, withMaxWaitTime: 5)

        }
        
    }
    
    static func GenerateEncounterSeries(forPlaneViewController planeViewController: PlaneViewController,withMaxLetter maxLetters: Int, withNumberOfEncounters numberOfEncounters: Int, withMaxFireballs maxFireballs: Int, withMaxSpikeBalls maxSpikeBalls: Int, withMaxSpaceCraft maxSpaceCraft: Int, withMaxAlienHeads maxAlienHeads: Int, withMaxWaitTime maxWaitTime: Int) -> EncounterSeries{
        
        if(numberOfEncounters < 2){
            fatalError("Error: there must be at least two encounters minimum in order for an encounter series to be generated")
        }
        
        let getMaxWaitTime = {
            
            return Double(4.00 + Double(arc4random_uniform(UInt32(maxWaitTime))))

        }
        
        
        let getRandomNumberOfSpikeBalls: ()->Int = {
            
            let maximumNum = maxSpikeBalls <= 0 ? 0: maxSpikeBalls
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
        
        let getRandomNumberOfFireballs: ()->Int = {
            
            let maximumNum = maxFireballs <= 0 ? 0: maxFireballs
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
        
        let getRandomNumberOfSpaceCraft: ()->Int = {
            
            let maximumNum = maxSpaceCraft <= 0 ? 0: maxSpaceCraft
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
        
        let getRandomNumberOfAlienHeads: ()->Int = {
            let maximumNum = maxAlienHeads <= 0 ? 0: maxAlienHeads
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
        
        let getRandomNumberOfLetters: ()->Int = {
            let maximumNum = maxLetters <= 0 ? 0: maxLetters
            
            return Int(arc4random_uniform(UInt32(maximumNum)))
            
        }
       
        
        let (firstWaitTime,fireballNum1,spikeBallNum1,spaceCraftNum1,letterNum1,alienHeadsNum1) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters(),getRandomNumberOfAlienHeads())
       
     
        
        let firstEncounter = Encounter(waitTime: firstWaitTime, numberOfSpikeBalls: spikeBallNum1, numberOfSpaceCraft: spaceCraftNum1, numberOfLetters: letterNum1, numberOfAlienHeads: alienHeadsNum1, numberOfFireballs: fireballNum1)
        
        let (secondWaitTime,fireballNum2,spikeBallNum2,spaceCraftNum2,letterNum2,alienHeadsNum2) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters(),getRandomNumberOfAlienHeads())
        
        
        
        var nextEncounter = firstEncounter.setNextEncounter(waitTime: secondWaitTime, numberOfSpikeBalls: spikeBallNum2, numberOfSpaceCraft: spaceCraftNum2, numberOfLetters: letterNum2, numberOfFireballs: fireballNum2, numberOfAlienHeads: alienHeadsNum2)
        
        for _ in 1..<numberOfEncounters-2{
            
            let (nextWaitTime,nextFireballNum,nextSpikeBallNum,nextSpaceCraftNum,nextNumberOfLetters,nextNumberOfAlienHeads) = (getMaxWaitTime(),getRandomNumberOfFireballs(),getRandomNumberOfSpikeBalls(),getRandomNumberOfSpaceCraft(),getRandomNumberOfLetters(),getRandomNumberOfAlienHeads())
            
            nextEncounter = nextEncounter.setNextEncounter(waitTime: nextWaitTime, numberOfSpikeBalls: nextSpikeBallNum, numberOfSpaceCraft: nextSpaceCraftNum, numberOfLetters: nextNumberOfLetters, numberOfFireballs: nextFireballNum, numberOfAlienHeads: nextNumberOfAlienHeads)
            
        }
        
        return EncounterSeries(planeViewController: planeViewController, firstEncounter: firstEncounter)
    }
    
    static func generateRandomNumberFunction(withDefaultValue defaultNum: Int, andWithMaxNumber max: Int) -> ()->Int{
        
        return {
            let maximumNum = max <= defaultNum ? defaultNum: max
        
            return Int(arc4random_uniform(UInt32(maximumNum)))
        }
    }
    
    static func showNumberOf(spikeballs: Int, spaceCraft: Int, alienHeads: Int, fireballs: Int, letters: Int, andWaitTime waitTime: Double){
        
        print("The generated wait time is: \(waitTime), generated spikeballs are: \(spikeballs), generated space craft are: \(spaceCraft), generated alien heads are: \(alienHeads), generated fireballs: \(fireballs), letters: \(letters)")
    }
}

class Encounter{
    
    var nextEncounter: Encounter?
    
    var waitTime: Double = 5.00
    
    var numberOfSpikeBalls: Int?
    var numberOfLetters: Int?
    var numberOfFireballs: Int?
    var numberOfSpaceCraft: Int?
    var numberOfAlienHeads: Int?
    

    init(waitTime: Double, numberOfSpikeBalls: Int?, numberOfSpaceCraft: Int?, numberOfLetters: Int?,numberOfAlienHeads: Int?, numberOfFireballs: Int?){
        
        self.waitTime = waitTime
        self.numberOfSpikeBalls = numberOfSpikeBalls
        self.numberOfSpaceCraft = numberOfSpaceCraft
        self.numberOfLetters = numberOfLetters
        self.numberOfFireballs = numberOfFireballs
        self.numberOfAlienHeads = numberOfAlienHeads
        
        nextEncounter = nil
    }
    
    func setNextEncounter(waitTime: Double, numberOfSpikeBalls: Int?, numberOfSpaceCraft: Int?, numberOfLetters: Int?, numberOfFireballs: Int?, numberOfAlienHeads: Int?) -> Encounter{
        
        self.nextEncounter = Encounter(waitTime: waitTime, numberOfSpikeBalls: numberOfSpikeBalls, numberOfSpaceCraft: numberOfSpaceCraft, numberOfLetters: numberOfLetters, numberOfAlienHeads: numberOfAlienHeads, numberOfFireballs: numberOfFireballs)
        
        return self.nextEncounter!
    }
    
    func getNextEncounter() -> Encounter?{
        
        return nextEncounter
    }
}
