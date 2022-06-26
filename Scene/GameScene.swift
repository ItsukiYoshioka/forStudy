//
//  GameScene.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/15.
//

import Foundation
import SpriteKit

class GameScene: SKScene{
    //ゲームを管理するインスタンス
    private var gameManager: GameManager!
    private var battlerType: Int!
    
    func setBattlerType(battlerType: Int){
        self.battlerType = battlerType
    }
    
    override func didMove(to view: SKView) {
        //背景色の変更
        self.backgroundColor = UIColor.white
        //ゲーム管理インスタンス作成
        self.gameManager = GameManager(scene: self, battlerType: self.battlerType)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            //押されたノードの取得
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            //スタートボタンが押された時
            if touchedNode.name == Constant.startButtonName || touchedNode.name == Constant.startButtonLabelName{
                self.gameManager.rouletteStart()
                return
            }
            
            //ストップボタンが押された時
            if let name = touchedNode.name{
                let pref = name.prefix(name.count - 1)
                if pref == Constant.stopButtonNamePref || pref == Constant.stopButtonLabelNamePref{
                    self.gameManager.rouletteStop(name: name)
                    return
                }
            }
            
            //ゲーム終了ボタンが押された時
            if touchedNode.name == Constant.endGameButtonName || touchedNode.name == Constant.endGameButtonLabelName{
                let startScene = StartScene()
                startScene.scaleMode = .resizeFill
                self.view!.presentScene(startScene)
            }
            
            //次のゲーム開始ボタンが押された時
            if touchedNode.name == Constant.nextGameButtonName || touchedNode.name == Constant.nextGameButtonLabelName{
                self.gameManager.goToNextGame()
            }
        }
    }
}
