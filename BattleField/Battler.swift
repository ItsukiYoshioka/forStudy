//
//  Battler.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/23.
//

import Foundation
import SpriteKit

class Battler: SKSpriteNode, Character{
    private let _maxHp: Int
    private var _hp: Int
    private let _maxLife: Int
    private var _life: Int
    private var _power: Int
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
    
    var maxLife: Int{
        self._maxLife
    }
    
    var life: Int{
        self._life
    }
    
    init(type: Int){
        self._maxHp = 20
        self._hp = 20
        self._power = 10
        self._maxLife = 3
        self._life = 3
        self.motion = Motion(type: type)
        let firstMotion = Motion(type: type).standingMotion
        super.init(texture: firstMotion, color: UIColor(), size: firstMotion.size())
        self.name = Constant.battlerName + String(type)
        self.size =  CGSize(width: 200.0, height: 170.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Battler{
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
        let dead = SKAction.animate(with: self.motion.deadMotion, timePerFrame: 0.2)
        self.run(dead)
    }
    
    func winPose(){
        let win = SKAction.animate(with: self.motion.winMotion, timePerFrame: 0.8)
        let forever = SKAction.repeatForever(win)
        self.run(forever)
    }
    
    func stopWinPose(){
        self.removeAllActions()
        self.texture = self.motion.standingMotion
    }
    
    //ライフを削って復活
    func revive(){
        self._life -= 1
        self._hp = self._maxHp
        self.texture = self.motion.standingMotion
    }
}

extension Battler{
    struct Motion{
        private let standing: String
        private let attack: [String]
        private let damaged: String
        private let dead: [String]
        private let win: String
        
        init(type: Int){
            self.standing = "battler\(type)_standing"
            self.damaged = "battler\(type)_damaged"
            self.win = "battler\(type)_win"
            
            var atk: [String] = []
            var dd: [String] = []
            for i in 1...4{
                atk.append("battler\(type)_attack\(i)")
                dd.append("battler\(type)_dead\(i)")
            }
            self.attack = atk
            self.dead = dd
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
            self.dead.map{ SKTexture(imageNamed: $0)}
        }
        
        var winMotion: [SKTexture]{
            [SKTexture(imageNamed: self.win), self.standingMotion]
        }
    }
}
