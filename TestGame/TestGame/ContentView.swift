//
//  ContentView.swift
//  TestGame
//
//  Created by 吉岡樹 on 2022/06/15.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene{
        let scene = GameScene()
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: self.scene)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
