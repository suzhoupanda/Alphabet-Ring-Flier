//
//  Array+HelperFunctions.swift
//  Mine Racer
//
//  Created by Aleksander Makedonski on 11/14/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation


extension Array{
    
    func getRandomElement() -> Any?{
        
        if(self.isEmpty){
            return nil
        }
        
        let count = self.count
        
        let randomIdx = Int(arc4random_uniform(UInt32(count)))
        
        return self[randomIdx]
        
    }
}
