//
//  Button.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/19.
//

import Foundation
import SpriteKit

class Button: SKShapeNode{
    private var label: SKLabelNode!
    
    override init(){
        super.init()
    }
    
    convenience init(size: CGSize, labelText: String, labelName: String, buttonName: String){
        self.init(rectOf: size)
        self.name = buttonName
        
        self.label = SKLabelNode()
        self.label.text = labelText
        self.label.fontName = Constant.font
        self.label.name = labelName
        self.label.horizontalAlignmentMode = .center
        self.label.fontColor = UIColor.white
        self.label.fontSize = 20.0
        self.addChild(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Button{
    func changeLabel(into text: String){
        self.label.text = text
    }
}
