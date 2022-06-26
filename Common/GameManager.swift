//
//  GameManager.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/21.
//

import Foundation
import SpriteKit

class GameManager{
    private var battleField: BattleField
    private var roulette: Roulette
    
    private var level: Int
    
    private let levelLabel: SKLabelNode
    private let winLoseLabel: SKLabelNode
    private let endGameButton: Button
    private let nextGameButton: Button
    
    init(scene: SKScene, battlerType: Int){
        self.roulette = Roulette(scene: scene)
        self.battleField = BattleField(scene: scene, battlerType: battlerType)
        self.level = 1
        
        //レベルラベルを作成
        self.levelLabel = SKLabelNode(fontNamed: Constant.font)
        self.levelLabel.name = Constant.levelLabelName
        self.levelLabel.text = "level: \(self.level)"
        self.levelLabel.fontColor = UIColor.green
        self.levelLabel.fontSize = 40
        self.levelLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY + 300.0)
        scene.addChild(self.levelLabel)
        
        //勝利か敗北かを示すラベルを作成
        self.winLoseLabel = SKLabelNode(fontNamed: Constant.font)
        self.winLoseLabel.name = Constant.winLoseLabelName
        self.winLoseLabel.fontSize = 60
        self.winLoseLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 150.0)
        self.winLoseLabel.isHidden = true
        scene.addChild(winLoseLabel)
        
        //ゲーム終了ボタンを作成
        let size = CGSize(width: 120.0, height: 70.0)
        self.endGameButton = Button(size: size, labelText: "End", labelName: Constant.endGameButtonLabelName, buttonName: Constant.endGameButtonName)
        self.endGameButton.position = CGPoint(x: scene.frame.midX / 2, y: scene.frame.midY - 250.0)
        self.endGameButton.fillColor = UIColor.gray
        self.endGameButton.isHidden = true
        scene.addChild(self.endGameButton)
        
        //次のゲーム開始ボタンを作成
        self.nextGameButton = Button(size: size, labelText: "Next", labelName: Constant.nextGameButtonLabelName, buttonName: Constant.nextGameButtonName)
        self.nextGameButton.position = CGPoint(x: scene.frame.midX + scene.frame.midX / 2, y: scene.frame.midY - 250.0)
        self.nextGameButton.fillColor = UIColor.red
        self.nextGameButton.isHidden = true
        scene.addChild(self.nextGameButton)
    }
}

extension GameManager{
    //ルーレット開始処理
    func rouletteStart(){
        self.roulette.start()
    }
    
    //ルーレットストップ処理
    func rouletteStop(name: String){
        let isStopAll = self.roulette.stop(name: name)
        if isStopAll{
            let isBattlerAttack = self.roulette.rouletteEndJudge()
            self.battleField.attackAction(isBattlerAttck: isBattlerAttack)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){ //攻撃アクションがきちんと終了してから次の処理へ
                if self.battleField.checkIsBattleEnded(){
                    //バトルが終了した場合の処理
                    //ルーレットは回せないように消去
                    self.roulette.hideAll()
                    //バトル終了処理（バトルフィールド内でのアクション）
                    self.battleField.endAction()
                    //ゲーム終了のアクション（バトルフィールド以外でのアクション）
                    self.gameEnd()
                }else{
                    //バトルが終了していない場合の処理
                    self.roulette.showStartButton()
                }
            }
        }
    }
    
    //ゲーム終了処理（バトルフィールド以外でのアクション）
    private func gameEnd(){
        if self.battleField.checkDidWin(){
            //勝った場合
            if self.level != Constant.maxLevel{
                //ボスへの勝利ではない場合
                self.winLoseLabel.text = "You Win!"
                self.winLoseLabel.fontColor = UIColor.red
                self.nextGameButton.changeLabel(into: "Next Game")
            }else{
                //ボスへの勝利の場合
                self.winLoseLabel.text = "Complete!!"
                self.winLoseLabel.fontColor = UIColor.orange
            }
        }else{
            //負けた場合
            if self.battleField.checkIsBattlerLifeRemain(){
                //ライフが残っている場合
                self.winLoseLabel.text = "You Lose..."
                self.winLoseLabel.fontColor = UIColor.blue
                self.nextGameButton.changeLabel(into: "Continue")
            }else{
                //ライフが０になった場合
                self.winLoseLabel.text = "Game Over"
                self.winLoseLabel.fontColor = UIColor.purple
            }
        }
        self.winLoseLabel.isHidden = false
        //ボタン表示は少し遅らせる
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.endGameButton.isHidden = false
            
            if self.battleField.checkIsBattlerLifeRemain() && self.level != Constant.maxLevel{
                //ライフが残っている時は次のゲームボタンを表示
                self.nextGameButton.isHidden = false
            }else{
                //ライフが０になった時、または、ボスに勝利した時、中央にゲーム終了ボタンを表示
                let scene = self.endGameButton.scene
                self.endGameButton.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.midY - 250.0)
            }
        }
    }
    
    //次のゲームへ行く処理
    func goToNextGame(){
        if self.battleField.checkDidWin(){
            self.level += 1
            self.levelLabel.text = self.level != Constant.maxLevel ? "level: \(self.level)" : "BOSS"
            self.battleField.goToNextField(level: self.level)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                //ステージ移動アクションが二秒かかるので、二秒後に実施
                self.roulette.makeRouletteReady(level: self.level)
            }
        }else{
            self.battleField.continueThisField()
            self.roulette.makeRouletteReady(level: self.level)
        }
        self.winLoseLabel.isHidden = true
        self.endGameButton.isHidden = true
        self.nextGameButton.isHidden = true
    }
}
