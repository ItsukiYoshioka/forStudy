//
//  GameScene.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/15.
//

import Foundation
import SpriteKit

class GameScene: SKScene{
    private let viewModel   : ViewModel    = ViewModel()
    private var girl        : SKSpriteNode = SKSpriteNode(imageNamed: "girl_smiling")
    private let nextButton  : SKShapeNode  = SKShapeNode(rectOf: CGSize(width: 200.0, height: 100.0))
    private let buttonLabel : SKLabelNode  = SKLabelNode()
    
    override func didMove(to view: SKView) {
        //背景色の変更
        self.backgroundColor = UIColor.white
        
        //笑顔の少女の画像を表示
        self.girl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addChild(self.girl)
        
        //ボタンを作成
        self.nextButton.name = "button"
        self.nextButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4)
        self.nextButton.fillColor = UIColor.blue
        self.addChild(self.nextButton)
        
        //ボタンのラベルを作成
        self.buttonLabel.text = "次を表示"
        self.buttonLabel.name = "label"
        self.buttonLabel.horizontalAlignmentMode = .center
        self.buttonLabel.fontColor = UIColor.white
        self.buttonLabel.fontSize = 20.0
        self.nextButton.addChild(self.buttonLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //少女切り替え
        for touch in touches{
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            if touchedNode.name == "button" || touchedNode.name == "label"{
                self.girl.texture = self.viewModel.getGirl()
            }
        }
    }
}
