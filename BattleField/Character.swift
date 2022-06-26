//
//  Character.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/23.
//

import Foundation

protocol Character{
    func attack(to character: Character)
    func damaged(by damage: Int)
    func dead()
}
