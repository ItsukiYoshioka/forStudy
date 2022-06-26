//
//  Enemy.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/23.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode, Character{
    private let _maxHp: Int
    private var _hp: Int
    private var _power: Int
    private let level: Int
    private let motion: Motion
    
    var maxHp: Int{
        self._maxHp
    }
    
    var hp: Int{
        self._hp
    }
    
    var power: Int{
        self._power
    }
    
    init(maxHp: Int, power: Int, level: Int){
        self._maxHp = maxHp
        self._hp = maxHp
        self._power = power
        self.level = level
        self.motion = Motion(level: level)
        let firstMotion = Motion(level: level).standingMotion
        super.init(texture: firstMotion, color: UIColor(), size: firstMotion.size())
        self.name = Constant.enemyName
        self.size =  CGSize(width: 170.0, height: 150.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Enemy{
    func attack(to character: Character){
        let attack = SKAction.animate(with: self.motion.attackMotion, timePerFrame: 0.2)
        self.run(attack)
        character.damaged(by: self._power)
    }
    
    func damaged(by damage: Int){
        self._hp -= damage
        let damaged = SKAction.animate(with: self.motion.damagedMotion, timePerFrame: 0.8)
        self.run(damaged)
        if self._hp > 0{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                self.texture = self.motion.standingMotion
            }
        }
    }
    
    func dead(){
        let dead = SKAction.animate(with: self.motion.deadMotion, timePerFrame: 0.8)
        self.run(dead)
    }
}

extension Enemy{
    struct Motion{
        private let standing: String
        private let damaged: String
        private let attack: [String]
        private let dead: String
        
        init(level: Int){
            self.standing = "enemy\(level)_standing"
            self.damaged = "enemy\(level)_damaged"
            self.dead = "enemy\(level)_dead"
            
            var atk: [String] = []
            for i in 1...4{
                atk.append("enemy\(level)_attack\(i)")
            }
            self.attack = atk
        }
        
        var standingMotion: SKTexture{
            SKTexture(imageNamed: self.standing)
        }
        
        var attackMotion: [SKTexture]{
            var atk = self.attack.map{ SKTexture(imageNamed: $0)}
            atk.append(self.standingMotion)
            return atk
        }
        
        var damagedMotion: [SKTexture]{
            [SKTexture(imageNamed: self.damaged)]
        }
        
        var deadMotion: [SKTexture]{
            [SKTexture(imageNamed: self.dead)]
        }
    }
}
