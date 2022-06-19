//
//  Button.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/19.
//

import Foundation
import SpriteKit

class Button: SKShapeNode{
    override init(){
        super.init()
    }
    
    convenience init(size: CGSize, labelText: String, labelName: String){
        self.init(rectOf: size)
        
        let label : SKLabelNode  = SKLabelNode()
        label.text = labelText
        label.fontName = "PixelMplus10-Regular"
        label.name = labelName
        label.horizontalAlignmentMode = .center
        label.fontColor = UIColor.white
        label.fontSize = 20.0
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
