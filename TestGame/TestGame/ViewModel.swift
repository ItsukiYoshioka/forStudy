//
//  ViewModel.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/18.
//

import Foundation
import SpriteKit

class ViewModel{
    enum girls: String{
        case girlSmiling   = "girl_smiling"
        case girlAngry     = "girl_angry"
        case girlConfusing = "girl_confusing"
    }
    
    private var girlShown: girls
    
    init(){
        self.girlShown = girls.girlSmiling
    }
    
    func getGirl() -> SKTexture{
        switch self.girlShown {
        case .girlSmiling:
            self.girlShown = .girlAngry
        case .girlAngry:
            self.girlShown = .girlConfusing
        case .girlConfusing:
            self.girlShown = .girlSmiling
        }
        
        return SKTexture(imageNamed: self.girlShown.rawValue)
    }
}
