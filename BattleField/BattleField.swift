//
//  BattleField.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/23.
//

import Foundation
import SpriteKit

class BattleField{
    private let battler: Battler
    private var enemy: Enemy
    private var currentField: SKSpriteNode
    private var nextField: SKSpriteNode
    private let battlerHpBar: SKShapeNode
    private let enemyHpBar: SKShapeNode
    private var hearts: [SKSpriteNode]
    
    init(scene: SKScene, battlerType: Int){
        //現在のフィールドを作成
        self.currentField = SKSpriteNode(imageNamed: "field1")
        self.currentField.name = Constant.currentFieldName
        self.currentField.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY + 100.0)
        self.currentField.size = CGSize(width: scene.frame.width, height: 250.0)
        scene.addChild(self.currentField)
        
        //次ステージのフィールドをこの時点で持っておく
        self.nextField = SKSpriteNode(imageNamed: "field2")
        self.nextField.name = Constant.nextFieldName
        self.nextField.position = CGPoint(x: scene.frame.width + scene.frame.width / 2, y: scene.frame.midY + 100.0)
        self.nextField.size = CGSize(width: scene.frame.width, height: 250.0)
        scene.addChild(self.nextField)
        
        //敵を表示
        self.enemy = Enemy(maxHp: 10, power: 10, level: 1)
        self.enemy.position = CGPoint(x: scene.frame.midX + scene.frame.midX / 2, y: scene.frame.midY + 80.0)
        scene.addChild(enemy)
        
        //敵のHPを表示
        let hpBarSize = CGSize(width: 200.0, height: 30.0)
        self.enemyHpBar = SKShapeNode(rectOf: hpBarSize)
        self.enemyHpBar.name = Constant.enemyHpBarName
        self.enemyHpBar.fillColor = .red
        self.enemyHpBar.position = CGPoint(x: scene.frame.midX + scene.frame.midX / 2, y: scene.frame.midY + 250.0)
        scene.addChild(self.enemyHpBar)
        
        //戦う人を表示
        self.battler = Battler(type: battlerType)
        self.battler.position = CGPoint(x: scene.frame.midX / 2, y: scene.frame.midY + 100.0)
        scene.addChild(self.battler)
        
        //バトラーのHPを表示
        self.battlerHpBar = SKShapeNode(rectOf: hpBarSize)
        self.battlerHpBar.name = Constant.battlerHpBarName
        self.battlerHpBar.fillColor = .blue
        self.battlerHpBar.position = CGPoint(x: scene.frame.midX / 2, y: scene.frame.midY + 250.0)
        scene.addChild(self.battlerHpBar)
        
        //バトラーのライフを表示
        self.hearts = []
        for i in 1...self.battler.maxLife{
            let heart = SKSpriteNode(imageNamed: "heart")
            heart.name = Constant.heartName + String(i)
            heart.position = CGPoint(x: 30.0 * Double(i), y: scene.frame.midY - 50.0)
            heart.size = CGSize(width: 30.0, height: 30.0)
            self.hearts.append(heart)
            scene.addChild(heart)
        }
    }
}

extension BattleField{
    func attackAction(isBattlerAttck: Bool){
        if isBattlerAttck{
            self.battler.attack(to: self.enemy)
            //HPバーのリサイズ
            if self.enemy.hp > 0{
                //敵がまだ生きている場合
                let hp = CGFloat(self.enemy.hp)
                let maxHp = CGFloat(self.enemy.maxHp)
                self.enemyHpBar.xScale = hp / maxHp
                let hpReducedBy = CGFloat(self.battler.power) / maxHp
                let posChangedBy = 200.0 * hpReducedBy / 2 //両端から縮められているため、２で割る
                self.enemyHpBar.position.x -= posChangedBy
            }else{
                //敵が死んだ場合
                self.enemyHpBar.xScale = 0
            }
        }else{
            self.enemy.attack(to: self.battler)
            //HPバーのリサイズ
            if self.battler.hp > 0{
                //バトラーがまだ生きている場合
                let hp = CGFloat(self.battler.hp)
                let maxHp = CGFloat(self.battler.maxHp)
                self.battlerHpBar.xScale = hp / maxHp
                let hpReducedBy = CGFloat(self.enemy.power) / maxHp
                let posChangedBy = 200.0 * hpReducedBy / 2 //両端から縮められているため、２で割る
                self.battlerHpBar.position.x += posChangedBy
            }else{
                //バトラーが死んだ場合
                self.battlerHpBar.xScale = 0
            }
        }
    }
    
    func checkIsBattleEnded() -> Bool{
        if self.battler.hp <= 0 || self.enemy.hp <= 0{
            return true
        }
        return false
    }
    
    func checkDidWin() -> Bool{
        if self.enemy.hp <= 0{
            return true
        }
        return false
    }
    
    func checkIsBattlerLifeRemain() -> Bool{
        return self.battler.life > 0 ? true : false
    }
    
    //バトル終了時のアクション処理
    func endAction(){
        if checkDidWin(){
            self.battler.winPose()
            self.enemy.dead()
        }else{
            self.battler.dead()
        }
    }
    
    //次の戦場へ行く処理
    func goToNextField(level: Int){
        //バトラーに勝利ポーズをやめさせる
        self.battler.stopWinPose()
        
        let scene = self.currentField.scene
        //敵を変更
        scene?.removeChildren(in: [self.enemy])
        self.enemy = Enemy(maxHp: 10 + (level - 1) * 5, power: 3 + (level - 1), level: level)
        self.enemy.position = CGPoint(x: scene!.frame.midX * 2 + scene!.frame.midX / 2, y: scene!.frame.midY + 80.0)
        scene?.addChild(self.enemy)
        //敵のHPを元に戻す
        self.enemyHpBar.xScale = 1.0
        self.enemyHpBar.position = CGPoint(x: scene!.frame.midX + scene!.frame.midX / 2, y: scene!.frame.midY + 250.0)
        //移動アクション
        let currentFieldAction = SKAction.moveTo(x: 0 - scene!.frame.width / 2, duration: 2.0)
        let nextFieldAction = SKAction.moveTo(x: scene!.frame.midX, duration: 2.0)
        let enemyAction = SKAction.moveTo(x: scene!.frame.midX + scene!.frame.midX / 2, duration: 2.0)
        self.currentField.run(currentFieldAction)
        self.nextField.run(nextFieldAction)
        self.enemy.run(enemyAction)
        //フィールドの入れ替え
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            //ステージ移動アクションが二秒かかるので、二秒後に実施
            self.currentField.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.midY + 100.0)
            self.currentField.texture = SKTexture(imageNamed: "field\(level)")
            self.nextField.position = CGPoint(x: scene!.frame.width + scene!.frame.width / 2, y: scene!.frame.midY + 100.0)
            self.nextField.texture = SKTexture(imageNamed: "field\(level + 1)")
            self.nextField.position = CGPoint(x: scene!.frame.width + scene!.frame.width / 2, y: scene!.frame.midY + 100.0)
        }
    }
    
    func continueThisField(){
        let scene = self.currentField.scene
        
        self.battler.revive()
        self.battlerHpBar.position = CGPoint(x: scene!.frame.midX / 2, y: scene!.frame.midY + 250.0)
        self.battlerHpBar.xScale = 1.0
        self.hearts[self.battler.life].isHidden = true
    }
}
