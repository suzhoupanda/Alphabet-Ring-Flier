//
//  SCNNode+Extension.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/15/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode{
    
    
    func configureWithEnemyPhysicsProperties(){
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.damping = 0.0
        self.physicsBody?.friction = 0.0
        
        self.physicsBody?.categoryBitMask = Int(CollisionMask.Enemy.rawValue)
        self.physicsBody?.collisionBitMask = Int(CollisionMask.Player.rawValue)
        self.physicsBody?.contactTestBitMask = Int(CollisionMask.Player.rawValue)
    }
    
    func configureWithBulletPhysicsProperties(){
        
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.damping = 0.0
        self.physicsBody?.friction = 0.0
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.rollingFriction = 0.0
        self.physicsBody?.mass = 2.00
        
        self.physicsBody?.categoryBitMask = Int(CollisionMask.Bullet.rawValue)
        self.physicsBody?.collisionBitMask = Int(CollisionMask.None.rawValue)
        self.physicsBody?.contactTestBitMask = Int(CollisionMask.Player.rawValue)
        
    }
    
    func configureWithDetectionNodePhysicsProperties(withName name: String){
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        self.opacity = 0.00
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: Date())
        
        self.name = "\(name)\(dateString)"
        
        self.physicsBody?.categoryBitMask = Int(CollisionMask.DetectionNode.rawValue)
        self.physicsBody?.collisionBitMask = Int(CollisionMask.None.rawValue)
        self.physicsBody?.contactTestBitMask = Int(CollisionMask.Player.rawValue)
        
        
    }
    
    func removeAfterTime(waitTime: Double){
        
        let removeAction = SCNAction.sequence([
            SCNAction.wait(duration: waitTime),
            SCNAction.sequence([
                SCNAction.fadeOut(duration: 1.00),
                SCNAction.removeFromParentNode()

                ])
            ])
        
        self.runAction(removeAction)
            
        
    }
    
    func runAction(completion: @escaping () -> (Void), afterTime timeInterval: TimeInterval){
        self.runAction(
            SCNAction.sequence([
                SCNAction.wait(duration: timeInterval),
                
                SCNAction.run({_ in
                    completion()
                    
                })]))
    }
    
}
