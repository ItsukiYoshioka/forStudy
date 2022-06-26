//
//  Girl.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/18.
//

import Foundation
import SpriteKit

class Girl: SKSpriteNode{
    enum facialExpression: String{
        case smiling     = "girl_smiling"
        case angry       = "girl_angry"
        case confusing   = "girl_confusing"
        case feelingDown = "girl_feelingDown"
        case surprising  = "girl_surprising"
        case indifferent = "girl_indifferent"
    }
    
    private var _currentFace: facialExpression
    private var timer: Timer!
    private var faceChangeSpeed: Double
    
    var currentFace: facialExpression{
        self._currentFace
    }
    
    init(name: String){
        self._currentFace = .smiling
        self.faceChangeSpeed = 0.5
        let firstFace = SKTexture(imageNamed: facialExpression.smiling.rawValue)
        super.init(texture: firstFace, color: UIColor(), size: firstFace.size())
        self.name = name
        self.size = CGSize(width: 100.0, height: 100.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Girl{
    //ルーレットの具体的処理。この関数を連続的に呼び出すことでルーレットを実現
    @objc private func changeFace(){
        switch _currentFace{
        case .smiling:
            self._currentFace = .angry
        case .angry:
            self._currentFace = .confusing
        case .confusing:
            self._currentFace = .smiling
        default:
            self._currentFace = .surprising
        }
        
        self.texture = SKTexture(imageNamed: self._currentFace.rawValue)
    }
    
    //ルーレットを開始する処理
    func startChangeFace(){
        self.timer = Timer.scheduledTimer(timeInterval: self.faceChangeSpeed, target: self, selector: #selector(self.changeFace), userInfo: nil, repeats: true)
    }
    
    //ルーレットを止める処理
    func stopChangeFace(){
        if self.timer == nil{
            return
        }
        self.timer.invalidate()
    }
    
    //ルーレットの速度を変更する処理
    func changeFaceChangeSpeed(level: Int){
        self.faceChangeSpeed = 0.5 / pow(1.5, Double(level - 1))
    }
}
