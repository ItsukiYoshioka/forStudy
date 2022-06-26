//
//  Constant.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/23.
//

import Foundation

class Constant{
    //ノードの名前を定義(Start Scene編）
    static let rightArrowName = "rightArrow"
    static let leftArrowName = "leftArrow"
    static let startGameButtonName = "gameStartButton"
    static let startGameButtonLabelName = "gameStartButtonLabel"
    
    //ノードの名前を定義(Game Scene編）
    static let levelLabelName = "levelLabel"
    static let resultLabelName = "resultLabel"
    static let girlNamePref = "girl"
    static let startButtonName = "startButton"
    static let startButtonLabelName = "startButtonLabel"
    static let stopButtonNamePref = "stopButton"
    static let stopButtonLabelNamePref = "stopButtonLabel"
    static let currentFieldName = "currentField"
    static let nextFieldName = "nextField"
    static let battlerName = "battler"
    static let enemyName = "enemy"
    static let battlerHpBarName = "battlerHpBar"
    static let enemyHpBarName = "enemyHpBar"
    static let heartName = "heart"
    static let winLoseLabelName = "winLoseLabel"
    static let endGameButtonName = "endGameButton"
    static let endGameButtonLabelName = "endGameButtonLabel"
    static let nextGameButtonName = "nextGameButton"
    static let nextGameButtonLabelName = "nextGameButtonLabel"
    
    //ラベル共通のフォントを定義
    static let font = "Thonburi-Bold"
    
    //バトラーの種類数を定義
    static let battlerKindNum = 7
    
    //ステージ数を定義
    static let fieldNum = 4
    
    //最大レベルを定義
    static let maxLevel = 4
}
