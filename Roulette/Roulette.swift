//
//  Roulette.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/23.
//

import Foundation
import SpriteKit

class Roulette{
    private let girl1: Girl
    private let girl2: Girl
    private let girl3: Girl
    
    private let startButton: Button
    
    private let stopButton1: Button
    private let stopButton2: Button
    private let stopButton3: Button
    
    private let resultLabel: SKLabelNode
    
    //少女がルーレット中かどうかを二進数のそれぞれのビットをフラグとして見立てて管理
    private var girlStatus = 0b000
    
    init(scene: SKScene){
        //ルーレット部分を作成
        self.girl1 = Girl(name: Constant.girlNamePref + String(1))
        self.girl2 = Girl(name: Constant.girlNamePref + String(2))
        self.girl3 = Girl(name: Constant.girlNamePref + String(3))
        self.girl1.position = CGPoint(x: scene.frame.width / 4 * 1, y: scene.frame.midY - 150.0)
        self.girl2.position = CGPoint(x: scene.frame.width / 4 * 2, y: scene.frame.midY - 150.0)
        self.girl3.position = CGPoint(x: scene.frame.width / 4 * 3, y: scene.frame.midY - 150.0)
        scene.addChild(self.girl1)
        scene.addChild(self.girl2)
        scene.addChild(self.girl3)
        
        //ストップボタンを作成
        var size = CGSize(width: 70.0, height: 50.0)
        self.stopButton1 = Button(size: size, labelText: "Stop!", labelName: Constant.stopButtonLabelNamePref + String(1), buttonName: Constant.stopButtonNamePref + String(1))
        self.stopButton2 = Button(size: size, labelText: "Stop!", labelName: Constant.stopButtonLabelNamePref + String(2), buttonName: Constant.stopButtonNamePref + String(2))
        self.stopButton3 = Button(size: size, labelText: "Stop!", labelName: Constant.stopButtonLabelNamePref + String(3), buttonName: Constant.stopButtonNamePref + String(3))
        self.stopButton1.position = CGPoint(x: scene.frame.width / 4 * 1, y: scene.frame.midY - 250.0)
        self.stopButton2.position = CGPoint(x: scene.frame.width / 4 * 2, y: scene.frame.midY - 250.0)
        self.stopButton3.position = CGPoint(x: scene.frame.width / 4 * 3, y: scene.frame.midY - 250.0)
        self.stopButton1.fillColor = UIColor.red
        self.stopButton2.fillColor = UIColor.red
        self.stopButton3.fillColor = UIColor.red
        self.stopButton1.isHidden = true
        self.stopButton2.isHidden = true
        self.stopButton3.isHidden = true
        scene.addChild(self.stopButton1)
        scene.addChild(self.stopButton2)
        scene.addChild(self.stopButton3)
        
        //スタートボタンを作成
        size = CGSize(width: 150.0, height: 70.0)
        self.startButton = Button(size: size, labelText: "Start!", labelName: Constant.startButtonLabelName, buttonName: Constant.startButtonName)
        self.startButton.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 250.0)
        self.startButton.fillColor = UIColor.blue
        scene.addChild(self.startButton)
        
        //結果表示ラベルを作成
        self.resultLabel = SKLabelNode(fontNamed: Constant.font)
        self.resultLabel.name = Constant.resultLabelName
        self.resultLabel.fontSize = 40
        self.resultLabel.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - 80.0)
        self.resultLabel.isHidden = true
        scene.addChild(self.resultLabel)
    }
}

extension Roulette{
    func start(){
        //少女の表情変化を開始
        self.girl1.startChangeFace()
        self.girl2.startChangeFace()
        self.girl3.startChangeFace()
        //ストップボタンを表示
        self.stopButton1.isHidden = false
        self.stopButton2.isHidden = false
        self.stopButton3.isHidden = false
        //ステータスのビットをすべて上げる
        self.girlStatus = 0b111
        //スタートボタンを消す
        self.startButton.isHidden = true
        //結果表示ラベルを消す
        self.resultLabel.isHidden = true
    }
    
    //ルーレットがすべて止まっていた場合、Trueを返す
    func stop(name: String) -> Bool{
        //少女の表情変化を止める
        let suffix = Int(name.suffix(1))
        var targetGirl: Girl
        var targetStopButton: Button
        switch suffix{
        case 1:
            targetGirl = self.girl1
            targetStopButton = self.stopButton1
        case 2:
            targetGirl = self.girl2
            targetStopButton = self.stopButton2
        default:
            targetGirl = self.girl3
            targetStopButton = self.stopButton3
        }
        targetGirl.stopChangeFace()
        //ボタンを消す
        targetStopButton.isHidden = true
        //フラグを下ろす
        let bit = pow(2, Double(suffix! - 1))
        self.girlStatus -= Int(bit)
        
        //ルーレットがすべて止まっている場合
        if self.girlStatus == 0b000{
            return true
        }
        
        return false
    }
    
    //バトラーの攻撃であればTrueを返す
    func rouletteEndJudge() -> Bool{
        let isAllFaceEqual = self.girl1.currentFace == self.girl2.currentFace &&
                             self.girl1.currentFace == self.girl3.currentFace
        if isAllFaceEqual{
            //ルーレットが揃った場合
            self.resultLabel.text = "Great!!"
            self.resultLabel.fontColor = .red
        }else{
            //ルーレットが揃わなかった場合
            self.resultLabel.text = "Failed"
            self.resultLabel.fontColor = .blue
        }
        //結果ラベルを表示
        self.resultLabel.isHidden = false
        
        return isAllFaceEqual
    }
    
    func showStartButton(){
        self.startButton.isHidden = false
    }
    
    func hideAll(){
        self.girl1.isHidden = true
        self.girl2.isHidden = true
        self.girl3.isHidden = true
        self.startButton.isHidden = true
        self.stopButton1.isHidden = true
        self.stopButton2.isHidden = true
        self.stopButton3.isHidden = true
        self.resultLabel.isHidden = true
    }
    
    func makeRouletteReady(level: Int){
        self.girl1.isHidden = false
        self.girl2.isHidden = false
        self.girl3.isHidden = false
        self.startButton.isHidden = false
        //ルーレットのスピードを変更
        self.girl1.changeFaceChangeSpeed(level: level)
        self.girl2.changeFaceChangeSpeed(level: level)
        self.girl3.changeFaceChangeSpeed(level: level)
    }
}
