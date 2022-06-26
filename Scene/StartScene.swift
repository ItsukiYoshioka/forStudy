//
//  StartScene.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/24.
//

import Foundation
import SpriteKit

class StartScene: SKScene{
    private var battlerType = 1
    
    override func didMove(to view: SKView) {
        //背景色の変更
        self.backgroundColor = UIColor.white
        
        //選択するバトラーを作成
        for i in 1...Constant.battlerKindNum{
            let battler = Battler(type: i)
            battler.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            battler.isHidden = i == 1 ? false : true //バトラータイプ１のみ初期表示
            self.addChild(battler)
        }
        
        //バトラー選択矢印を作成(右）
        let rightArrow = SKSpriteNode(imageNamed: "right_arrow1")
        rightArrow.name = Constant.rightArrowName
        rightArrow.position = CGPoint(x: self.frame.midX + self.frame.midX / 2, y: self.frame.midY - 100.0)
        rightArrow.size = CGSize(width: 50.0, height: 50.0)
        self.addChild(rightArrow)
        
        //バトラー選択矢印を作成(左）
        let leftArrow = SKSpriteNode(imageNamed: "left_arrow1")
        leftArrow.name = Constant.leftArrowName
        leftArrow.position = CGPoint(x: self.frame.midX / 2, y: self.frame.midY - 100.0)
        leftArrow.size = CGSize(width: 50.0, height: 50.0)
        leftArrow.isHidden = true
        self.addChild(leftArrow)
        
        //ゲーム開始ボタンを作成
        let size = CGSize(width: 200.0, height: 100.0)
        let startGameButton = Button(size: size, labelText: "Game Start", labelName: Constant.startGameButtonLabelName, buttonName: Constant.startGameButtonName)
        startGameButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 250.0)
        startGameButton.fillColor = UIColor.red
        self.addChild(startGameButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            //押されたノードの取得
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            //ゲーム開始ボタンが押された時
            if touchedNode.name == Constant.startGameButtonName || touchedNode.name == Constant.startGameButtonLabelName{
                let transition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
                let gameScene = GameScene()
                gameScene.setBattlerType(battlerType: self.battlerType)
                gameScene.scaleMode = .resizeFill
                self.view!.presentScene(gameScene, transition: transition)
                return
            }
            
            //右矢印が押された時
            if touchedNode.name == Constant.rightArrowName{
                self.battlerType += 1
                let beforeBattler = self.childNode(withName: Constant.battlerName + String(self.battlerType - 1)) as? Battler
                let afterBattler = self.childNode(withName: Constant.battlerName + String(self.battlerType)) as? Battler
                beforeBattler?.isHidden = true
                afterBattler?.isHidden = false
                
                if self.battlerType == 2{
                    let leftArrow = self.childNode(withName: Constant.leftArrowName) as? SKSpriteNode
                    leftArrow?.isHidden = false
                }
                
                if self.battlerType >= Constant.battlerKindNum{
                    //バトラーの数だけ右に進んだら、右矢印を隠す
                    touchedNode.isHidden = true
                }
            }
            
            //左矢印が押された時
            if touchedNode.name == Constant.leftArrowName{
                self.battlerType -= 1
                let beforeBattler = self.childNode(withName: Constant.battlerName + String(self.battlerType + 1)) as? Battler
                let afterBattler = self.childNode(withName: Constant.battlerName + String(self.battlerType)) as? Battler
                beforeBattler?.isHidden = true
                afterBattler?.isHidden = false
                
                if self.battlerType == Constant.battlerKindNum - 1{
                    let rightArrow = self.childNode(withName: Constant.rightArrowName) as? SKSpriteNode
                    rightArrow?.isHidden = false
                }
                
                if self.battlerType <= 1{
                    touchedNode.isHidden = true
                }
            }
        }
    }
}
