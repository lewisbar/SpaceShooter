//
//  Enemy.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 13.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode, SpaceSprite {
    
    var health: Int = 1
    
    init() {
        let texture = SKTexture(imageNamed: "Whirl Folded")
        super.init(texture: texture, color: .clear, size: texture.size())
        physicsBody = SKPhysicsBody(texture: self.texture!, size: (self.texture?.size())!) // circleOfRadius: size.width / 2)
        physicsBody?.allowsRotation = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
