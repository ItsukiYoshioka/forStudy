//
//  GameScene.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/15.
//

import Foundation
import SpriteKit

class GameScene: SKScene{
    //共通のフォントを定義
    private let commonFont = "PixelMplus10-Regular"
    //ノードの名前を定義
    private let pointLabelName = "pointLabel"
    private let levelLabelName = "levelLabel"
    private let resultLabelName = "resultLabel"
    private let girlNamePref = "girl"
    private let startButtonName = "startButton"
    private let startButtonLabelName = "startButtonLabel"
    private let stopButtonNamePref = "stopButton"
    private let stopButtonLabelNamePref = "stopButtonLabel"
    //少女がルーレット中かどうかを二進数のそれぞれのビットをフラグとして見立てて管理
    private var girlStatus = 0b000
    //ゲームの得点やレベルを管理するインスタンス
    private let gameManager = GameManager()
    
    override func didMove(to view: SKView) {
        //背景色の変更
        self.backgroundColor = UIColor.white
        
        //得点ラベルを表示
        let pointLabel = SKLabelNode(fontNamed: self.commonFont)
        pointLabel.name = self.pointLabelName
        pointLabel.text = "point: \(self.gameManager.point)"
        pointLabel.fontColor = UIColor.black
        pointLabel.fontSize = 20
        pointLabel.position = CGPoint(x: 50.0, y: self.frame.height - 100.0)
        addChild(pointLabel)
        
        //レベルラベルを表示
        let levelLabel = SKLabelNode(fontNamed: self.commonFont)
        levelLabel.name = self.levelLabelName
        levelLabel.text = "level: \(self.gameManager.level)"
        levelLabel.fontColor = UIColor.green
        levelLabel.fontSize = 40
        levelLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 200.0)
        addChild(levelLabel)
        
        //結果表示ラベルを作成
        let resultLabel = SKLabelNode(fontNamed: self.commonFont)
        resultLabel.name = self.resultLabelName
        resultLabel.fontSize = 50
        resultLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100.0)
        resultLabel.isHidden = true
        addChild(resultLabel)
        
        //少女の画像を表示
        for i in 0..<3{
            let girl = Girl()
            girl.position = CGPoint(x: self.frame.width / 4 * CGFloat(i + 1), y: self.frame.midY)
            girl.name = self.girlNamePref + String(i)
            self.addChild(girl)
        }
        
        //ストップボタンを作成
        for i in 0..<3{
            let size = CGSize(width: 70.0, height: 50.0)
            let button = Button(size: size, labelText: "Stop!", labelName: self.stopButtonLabelNamePref + String(i))
            button.position = CGPoint(x: self.frame.width / 4 * CGFloat(i + 1), y: self.frame.midY - 100.0)
            button.name = self.stopButtonNamePref + String(i)
            button.fillColor = UIColor.red
            button.isHidden = true
            self.addChild(button)
        }
        
        //スタートボタンを表示
        let size = CGSize(width: 150.0, height: 70.0)
        let startButton = Button(size: size, labelText: "Start!", labelName: self.startButtonLabelName)
        startButton.name = self.startButtonName
        startButton.position = CGPoint(x: self.frame.midX, y: self.frame.height / 4)
        startButton.fillColor = UIColor.blue
        self.addChild(startButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            //押されたノードの取得
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            //スタートボタンが押された時
            if touchedNode.name == self.startButtonName || touchedNode.name == self.startButtonLabelName{
                for i in 0..<3{
                    //少女の表情変化を開始
                    let girl = childNode(withName: self.girlNamePref + String(i)) as? Girl
                    girl?.startChangeFace()
                    //ストップボタンを表示
                    let stopButton = childNode(withName: self.stopButtonNamePref + String(i)) as? Button
                    stopButton?.isHidden = false
                }
                //ステータスのビットをすべて上げる
                self.girlStatus = 0b111
                //スタートボタンを消す
                let startButton = childNode(withName: self.startButtonName) as? Button
                startButton?.isHidden = true
                //結果表示ラベルを消す
                let resultLabel = childNode(withName: self.resultLabelName) as? SKLabelNode
                resultLabel?.isHidden = true
            }
            
            //ストップボタンが押された時
            if let name = touchedNode.name{
                let pref = name.prefix(name.count - 1)
                if pref == self.stopButtonNamePref || pref == self.stopButtonLabelNamePref{
                    //少女の表情変化を止める
                    let suffix = name.suffix(1)
                    let girl = childNode(withName: self.girlNamePref + suffix) as? Girl
                    girl?.stopChangeFace()
                    //ボタンを消す
                    let stopButton = childNode(withName: self.stopButtonNamePref + suffix) as? Button
                    stopButton?.isHidden = true
                    //フラグを下ろす
                    let bit = pow(2, Double(suffix)!)
                    self.girlStatus -= Int(bit)
                    
                    //ルーレットがすべて止まっている場合
                    if self.girlStatus == 0b000{
                        self.rouletteEnded()
                    }
                }
            }
        }
    }
    
    private func rouletteEnded(){
        let girl0 = childNode(withName: self.girlNamePref + "0") as? Girl
        let girl1 = childNode(withName: self.girlNamePref + "1") as? Girl
        let girl2 = childNode(withName: self.girlNamePref + "2") as? Girl
        
        let pointLabel = childNode(withName: self.pointLabelName) as? SKLabelNode
        let levelLabel = childNode(withName: self.levelLabelName) as? SKLabelNode
        let resultLabel = childNode(withName: self.resultLabelName) as? SKLabelNode
        
        if girl0?.currentFace == girl1?.currentFace && girl0?.currentFace == girl2?.currentFace{
            //ルーレットが揃った場合
            resultLabel?.text = "Great!!"
            resultLabel?.fontColor = .red
            
            self.gameManager.rouletteSucceeded()
            pointLabel?.text = "point: \(self.gameManager.point)"
            levelLabel?.text = "level: \(self.gameManager.level)"
        }else{
            //ルーレットが揃わなかった場合
            resultLabel?.text = "Failed"
            resultLabel?.fontColor = .blue
            
            self.gameManager.rouletteFailed()
            levelLabel?.text = "level: \(self.gameManager.level)"
        }
        
        //次のルーレットの速度に変更を加える
        let changeSpeed = self.gameManager.changeSpeed
        girl0?.changeFaceChangeSpeed(speed: changeSpeed)
        girl1?.changeFaceChangeSpeed(speed: changeSpeed)
        girl2?.changeFaceChangeSpeed(speed: changeSpeed)
        
        resultLabel?.isHidden = false
        
        let startButton = childNode(withName: self.startButtonName) as? Button
        startButton?.isHidden = false
    }
}
