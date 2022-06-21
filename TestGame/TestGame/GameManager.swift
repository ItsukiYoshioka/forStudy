//
//  GameManager.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/21.
//

import Foundation

class GameManager{
    //何度連続で失敗したらレベルダウンさせるかの定義
    private let baselineForFailCountRepeat = 5
    
    private var _level: Int
    private var _point: Int
    private var failCount: Int
    
    var level: Int{
        self._level
    }
    
    var point: Int{
        self._point
    }
    
    var changeSpeed: Double{
        0.5 / Double(self.level)
    }
    
    init(){
        self._level = 1
        self._point = 0
        self.failCount = 0
    }
}

extension GameManager{
    //ルーレットを揃えた場合の処理
    func rouletteSucceeded(){
        self._level += 1
        self._point += 1
        //失敗数のリセット
        self.failCount = 0
    }
    
    //ルーレットを外した場合の処理
    func rouletteFailed(){
        self.failCount += 1
        
        //連続で失敗した際のレベルダウン基準に達した場合、レベルダウンさせる。
        if self.failCount >= self.baselineForFailCountRepeat{
            self._level -= 1
            //失敗数のリセット
            self.failCount = 0
        }
    }
}
