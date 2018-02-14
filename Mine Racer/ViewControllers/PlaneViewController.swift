//
//  PlaneViewController.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import QuartzCore
import SceneKit
import SpriteKit

class PlaneViewController: UIViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var indicatorViewCenterXConstraint: NSLayoutConstraint!
    
    
    //MARK: SCNView
    
    var scnView: SCNView!
    
    //MARK: ******** Scenes

    var scnScene: SCNScene!
    var preambleScene: SCNScene!
    
    //MARK: ******** Preamble Reference Nodes
    
    var startMenu: SCNNode!
    var gameOptionsMenu: SCNNode!
    var levelTrackMenu: SCNNode!
    var planeColorMenu: SCNNode!
    
    var startGameOption: SCNNode!
    var gameDifficultyOption: SCNNode!
    var levelTracksOption: SCNNode!
    var planeColorOption: SCNNode!
    
    var redOption: SCNNode!
    var yellowOption: SCNNode!
    var blueOption: SCNNode!
    
    var hardOption: SCNNode!
    var mediumOption: SCNNode!
    var easyOption: SCNNode!
    
    var spaceShipsOption: SCNNode!
    var fireballsOption: SCNNode!
    var alienHeadsOption: SCNNode!
    var spikeBallsOption: SCNNode!
    
    
    var lastContactNode: SCNNode!
    
    var gameHelper: GameHelper{
        return GameHelper.sharedInstance
    }
    
    var hud: HUD!
    
    var mainHUDnode: SCNNode{
        return hud.hudNode
    }
    
    
    var player: Plane!
    
    var worldNode: SCNNode!
    var menuNode: SCNNode!
    var pauseMenu: SCNNode!
    var gameOverMenu: SCNNode!
    var gameWinMenu: SCNNode!
    var pauseText: SCNText?
    
    var followPortraitCameraNode: SCNNode!
    var followLandscapeCameraNode: SCNNode!
    
    var portraitCamera: SCNNode!
    var landscapeCamera: SCNNode!
    
    var letterRingManager: LetterRingManager!
    var spaceCraftManager: SpaceCraftManager!
    var spikeBallManager: SpikeBallManager!
    var fireballManager: FireballManager!
    var alienHeadManager: AlienHeadManager!
    
    var currentWord: String?
    var wordInProgress: String?
    var restartWord: String?
    var tempWord: String?
    var spawnPoints: [[SCNVector3]]?
    
    var lastUpdatedTime: TimeInterval = 0.00
    var frameCount: TimeInterval = 0.00
    var ringExpansionInterval = 4.00
    
    var currentEncounterSeries: EncounterSeries?
    var encounterIsFinished: Bool = false{
        didSet{
            if(encounterIsFinished == true){
                self.worldNode.runAction(completion: {
                    self.gameHelper.state = .GameOver
                    self.showGameLossMenu(withReason: "OUT OF TIME!")
                    print("Encounter is finished...Game over")
                    
                }, afterTime: 1.00)
                
              
            }
        }
    }
    
    var engineAudioSource: SCNAudioSource?{
        return AudioManager.sharedInstance.getAudioSource(ofType: .engine1)
    }
    
    //MAKR:     Word Arrays
    
    var easyWords: [String]?
    var mediumWords: [String]?
    var hardWords: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        indicatorViewCenterXConstraint.constant = -2000
        activityIndicator.stopAnimating()
 
        registerNotifications()
        
        setupView()
        
        
    
        setupPreambleScene()
        
        setupPreambleNodes()
        
        loadPreambleScene()
     
    }
    
    
    func registerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(pauseGame(notification:)), name: Notification.Name.GetPauseNotification(), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(unpauseGame(notification:)), name: Notification.Name.GetUnPauseNotification(), object: nil)

    }
    
    @objc func pauseGame(notification: Notification?){
        if(gameHelper.state == .Playing){
            self.scnScene.isPaused = true
            self.worldNode.isPaused = true
        }
    }
    
    @objc func unpauseGame(notification: Notification?){
        if(gameHelper.state == .Playing){
            self.scnScene.isPaused = false
            self.worldNode.isPaused = false
        }
    }
    
    
    func loadAppIconScene(){
        scnView.scene = SCNScene(named: "art.scnassets/scenes/AppIconScene.scn")
    }
    
    func loadPreambleScene(){
        
        scnView.scene = self.preambleScene
        
    }
    
    func loadGame(){
        
        
        activityIndicator.startAnimating()
        
        preloadTargetWordArray()
        
        configureDifficultyAdjustedWord()
        
        resetWordInProgress()
        
        //TODO: combine in a single function and load/update managers dynamically based upon current level track
        
        
        loadAlienHeadManager()
        
        loadFireballManager()
        
        loadSpikeBallManager()
        
        loadLetterRingManager()
        
        loadSpaceCraftManager()
        
    
        loadScene()
        
        setupNodes()
        
        setupCameras()
        
        setupHUD()
        
        loadMenuNode()
        
        setupGestureRecognizers()
        
        changePointOfView(to: .Portrait)
        
        gameHelper.state = .Playing
        
        
        loadEncounterSeries()
        
        startEncounterSeries()
        
        AudioManager.sharedInstance.addSound(ofType: .gameStart, toNode: self.player.node, removeAfter: 1.00)
        
        activityIndicator.stopAnimating()
        indicatorViewCenterXConstraint.constant = -2000
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.view.layoutIfNeeded()
        })
        

    }
    
    func cleanUpEnemyManagers(){
        self.fireballManager = nil
        self.spikeBallManager = nil
        self.spaceCraftManager = nil
        self.alienHeadManager = nil
        self.letterRingManager = nil
    }
    
    
    func resetWordInProgress(){
        self.wordInProgress = nil
        self.wordInProgress = String()
        self.tempWord = nil
        self.tempWord = self.currentWord!
    }
    
    func preloadTargetWordArray(){
        
        self.easyWords = nil
        self.mediumWords = nil
        self.hardWords = nil
        
        let path = Bundle.main.path(forResource: "TargetWords", ofType: "plist")!
       
        let wordsDict = NSDictionary(contentsOfFile: path)!
   
        let wordsArray = wordsDict[gameHelper.difficulty.rawValue] as! [String]
        
        switch self.gameHelper.difficulty {
        case .Easy:
            self.easyWords = wordsArray
            break
        case .Medium:
            self.mediumWords = wordsArray
            break
        case .Hard:
            self.hardWords = wordsArray
            break
        }
        
    }
    
    func configureDifficultyAdjustedWord(){
        
        if let restartWord = self.restartWord{
            
            setCurrentWord(with: restartWord)
            
        } else {
        
        var targetWord: String!
        
            if let easyWords = self.easyWords{
            
                targetWord = easyWords.getRandomElement() as! String

            
            } else if let hardWords = self.hardWords{
            
                targetWord = hardWords.getRandomElement() as! String
      
            
            } else if let mediumWords = self.mediumWords{
            
                targetWord = mediumWords.getRandomElement() as! String

            }
        
        
            setCurrentWord(with: targetWord)
        }
    }
    
    
   
        
    func loadEncounterSeries(){
        
        print("Loading encounter series of Level Track: \(gameHelper.levelTrack.rawValue), for Difficulty Level of: \(gameHelper.difficulty.rawValue), Level: \(gameHelper.level)")
        
        
        if let currentEncounterSeries = self.currentEncounterSeries{
            
            currentEncounterSeries.terminateEncounterSeries()
            self.currentEncounterSeries = nil
        }
        
        self.currentEncounterSeries = EncounterSeries.GenerateEncounterSeries(forPlaneViewController: self, forLevelTrack: gameHelper.levelTrack, andforLevel: gameHelper.level)


        self.currentEncounterSeries!.showFirstEncounterInformation()
        
    }
    
    func startEncounterSeries(){
        if(self.currentEncounterSeries != nil){
            self.currentEncounterSeries!.start()

        }

    }
    
    func setupHUD(){
        self.hud = HUD(withPlaneViewController: self)
        self.portraitCamera.addChildNode(self.hud.hudNode)
        self.hud.hudNode.position = SCNVector3.init(0.0, 45.00, -100.00)
        self.hud.updateHUD()
    
    }
    
    func setCurrentWord(with word: String){
        
        self.currentWord = word.uppercased()
    }
    
    func spawnNextGameObject(){
        
        
        
    }
    

    
    
    func getRandomSpawnPoint() -> SCNVector3{
        
        let numberOfGroups = spawnPoints!.count
        let groupIdx = Int(arc4random_uniform(UInt32(numberOfGroups)))
        
        let groupSpawnPoints = self.spawnPoints![groupIdx]
        
        let numberOfPoints = groupSpawnPoints.count
        let pointIdx = Int(arc4random_uniform(UInt32(numberOfPoints)))
        
        return groupSpawnPoints[pointIdx]
    }
    
    func loadSpawnPoints(){
        
        print("Loading spawn points....")
        
        spawnPoints = [[SCNVector3]]()
        
        for node in scnScene.rootNode.childNodes{
            if node.name != nil && node.name!.contains("SpawnPointGroup"){
                
                let spawnPointGroup = node.childNodes.filter({$0.name == "SpawnPoint"}).map({$0.position})
                
                spawnPoints!.append(spawnPointGroup)
           
                
            }
        }
        
    
        spawnPoints!.forEach({
            
           spawnGroup in
            
            var i = 0

            print("Showing inform for spawn point group \(i+1)")
            
            spawnGroup.forEach({
                spawnPoint in
                
                
                print("Spawn point group \(i+1) located at x: \(spawnPoint.x), y: \(spawnPoint.y), z: \(spawnPoint.z)")
                
            })
           
            i += 1
            
        })
    }
    
    
    /** Helper functions for setting up the Preamble **/
    
    func loadScene(){
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.50)
    
        
        scnScene = SCNScene(named: "art.scnassets/scenes/blue_scene.scn")
        
        scnScene.physicsWorld.contactDelegate = self
        
        scnScene.background.contents = BackgroundManager.GetRandomSkyBoxPath()
        
        scnView.present(self.scnScene, with: transition, incomingPointOfView: nil, completionHandler: nil)
        
    }
    
    func setupPreambleNodes(){
        
        
        /** Option Menus **/
        
        self.startMenu = preambleScene.rootNode.childNode(withName: "StartMenu", recursively: true)!
        self.gameOptionsMenu = preambleScene.rootNode.childNode(withName: "GameOptions", recursively: true)!
        self.levelTrackMenu = preambleScene.rootNode.childNode(withName: "LevelTracks", recursively: true)!
        self.planeColorMenu = preambleScene.rootNode.childNode(withName: "PlaneColors", recursively: true)!
        
        /** Start Menu Options **/
        
        self.startGameOption = self.startMenu.childNode(withName: "StartGame", recursively: true)!
        self.gameDifficultyOption = self.startMenu.childNode(withName: "GameOptions", recursively: true)!
        self.levelTracksOption = self.startMenu.childNode(withName: "LevelTracks", recursively: true)!
        self.planeColorOption = self.startMenu.childNode(withName: "PlaneColors", recursively: true)!
        
        
        /** Plane Color Options **/
        
        self.redOption = self.planeColorMenu.childNode(withName: "Red", recursively: true)!
        self.blueOption = self.planeColorMenu.childNode(withName: "Blue", recursively: true)!
        self.yellowOption = self.planeColorMenu.childNode(withName: "Yellow", recursively: true)!
        
        /** Game Difficulty Options **/
        
        self.hardOption = self.gameOptionsMenu.childNode(withName: "Hard", recursively: true)!
        self.mediumOption = self.gameOptionsMenu.childNode(withName: "Medium", recursively: true)!
        self.easyOption = self.gameOptionsMenu.childNode(withName: "Easy", recursively: true)!

        /** Game Level Track Options  **/

        self.spaceShipsOption = self.levelTrackMenu.childNode(withName: "SpaceShips", recursively: true)!
        self.alienHeadsOption = self.levelTrackMenu.childNode(withName: "AlienHeads", recursively: true)!
        self.fireballsOption = self.levelTrackMenu.childNode(withName: "FireBalls", recursively: true)!
        self.spikeBallsOption = self.levelTrackMenu.childNode(withName: "SpikeBalls", recursively: true)!
        
        positionStartMenu(isShowing: true)


    }
    
    func setupPreambleScene(){
        
        preambleScene = SCNScene(named: "art.scnassets/scenes/SplashScene.scn")
        
        gameHelper.state = .TapToPlay


    }
    
  
    
    func loadAlienHeadManager(){
        alienHeadManager = AlienHeadManager(with: self)
    }
    
    func loadFireballManager(){
        fireballManager = FireballManager(with: self)
    }
    
    func loadSpikeBallManager(){
    
        spikeBallManager = SpikeBallManager(with: self)
    
    }
    
    func loadSpaceCraftManager(){
        spaceCraftManager = SpaceCraftManager(with: self)
    }
    
    func loadLetterRingManager(){
        letterRingManager = LetterRingManager(with: self)
    }
    
    func setupView(){
        scnView = view as! SCNView
        
        scnView.delegate = self
        
        scnView.scene = scnScene
        
        scnView.allowsCameraControl = false
        

        
    }
    
    func setupGestureRecognizers(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self.player, action: #selector(Plane.handleGesture(_:)))
        swipeRight.direction = .right
        scnView.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft = UISwipeGestureRecognizer(target: player, action: #selector(Plane.handleGesture(_:)))
        swipeLeft.direction = .left
        scnView.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp = UISwipeGestureRecognizer(target: player, action: #selector(Plane.handleGesture(_:)))
        swipeUp.direction = .up
        scnView.addGestureRecognizer(swipeUp)
        
        
        let swipeDown = UISwipeGestureRecognizer(target: player, action: #selector(Plane.handleGesture(_:)))
        swipeDown.direction = .down
        scnView.addGestureRecognizer(swipeDown)
        
        
    }

   
    func setupEngineAudioPlayer(){
        if let engineAudioSrc = self.engineAudioSource{
            
            let audioPlayer = SCNAudioPlayer(source: engineAudioSrc)
            self.worldNode.addAudioPlayer(audioPlayer)
            
            audioPlayer.didFinishPlayback = {
                self.setupEngineAudioPlayer()
            }
            
        }
    }
    
    func removeEngineAudioPlayer(){
        worldNode.removeAllAudioPlayers()
    }
    
    func setupNodes(){
        
        print("Binding to references nodes...")
        
        // carNode = scene.rootNode.childNode(withName: "carFormula", recursively: true)!
        
        let planeName = gameHelper.planeType.getPlaneReferenceNodeName()
        
        let planeReferenceNode = scnScene.rootNode.childNode(withName: planeName, recursively: true)!
        
        player = Plane(withReferenceNode: planeReferenceNode)
        
        player.node.position = SCNVector3.init(0.0, 0.0, 0.0)
        
        
        followPortraitCameraNode = scnScene.rootNode.childNode(withName: "followPortraitCamera", recursively: true)!
        followLandscapeCameraNode = scnScene.rootNode.childNode(withName: "followLandscapeCamera", recursively: true)!
        
        worldNode = SCNNode()
        scnScene.rootNode.addChildNode(worldNode)
        
    
       
    }
    
    /** Bind the camera nodes from the SCNScene file to references in code **/
    
    func setupCameras(){
        
        
        portraitCamera = scnScene.rootNode.childNode(withName: "portraitCamera", recursively: true)!
        landscapeCamera = scnScene.rootNode.childNode(withName: "landscapeCamera", recursively: true)!
    
     

    }

    func returnToMainMenu(){
        
        print("Executing returnToMainMenu function....")
        
        let transition = SKTransition.flipVertical(withDuration: 0.50)
        self.scnView.present(self.preambleScene, with: transition, incomingPointOfView: nil, completionHandler: {
            
            self.positionStartMenu(isShowing: true)
            self.gameHelper.state = .TapToPlay
            self.currentWord = nil
            self.restartWord = nil
            if let currentEncounterSeries = self.currentEncounterSeries{
                currentEncounterSeries.terminateEncounterSeries()
                self.currentEncounterSeries = nil
            }
            self.gameHelper.level = 1
            self.cleanUpEnemyManagers()
            
        })
    }
    
    func restartCurrentLevel(){
        self.cleanUpEnemyManagers()
        
        if let currentEncounterSeries = self.currentEncounterSeries{
            currentEncounterSeries.terminateEncounterSeries()
            self.currentEncounterSeries = nil
        }
        
        self.restartWord = self.currentWord!
        
        loadGame()
    }
    
    func loadNextLevel(){
        
        gameHelper.level += 1
        self.cleanUpEnemyManagers()
      
        
        if let currentEncounter = self.currentEncounterSeries{
            currentEncounter.terminateEncounterSeries()
            self.currentEncounterSeries = nil
        }
        
        self.currentWord = nil
        self.restartWord = nil
        
        loadGame()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            changePointOfView(to: .Portrait)
            break
        case .landscapeLeft,.landscapeRight:
            changePointOfView(to: .Landscape)
            break
        default:
            break
        }
    }

    //TODO: add HUD to the camera node to keep it in position
    
    func changePointOfView(to pointOfView: PointOfView){
        
        /** Remove HUD node from previous camera node **/
        if let currentCamera = scnView.pointOfView{
            if let hudNode = currentCamera.childNode(withName: "hud", recursively: true){
                hudNode.removeFromParentNode()
            }
        }
        
        switch pointOfView {
        case .SideView:
            break
        case .BirdsEye:
            break
        case .Landscape:
            scnView.pointOfView = self.landscapeCamera
            break
        case .Portrait:
            scnView.pointOfView = self.portraitCamera
            break
        case .FirstPerson:
            break
            
        }
        
        /** Add HUD node to new camera node **/
        
        if let currentCamera = scnView.pointOfView{
                currentCamera.addChildNode(mainHUDnode)
            
        }
    }
    
    
    func updateCameraPositions(){
        
        followPortraitCameraNode.position = player.node.presentation.position
        followLandscapeCameraNode.position = player.node.presentation.position
        
    }
    
}

