//
//  FireBall.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 13.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class FireBall: SKSpriteNode, SpaceSprite {
    
    var health: Int = 1
    
    init() {
        let texture = SKTexture(imageNamed: "Sternschuss")
        super.init(texture: texture, color: .clear, size: texture.size())
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(at aim: CGPoint) {
        let shoot = SKAction.move(to: aim, duration: 1)
        let removeFireBall = SKAction.removeFromParent()
        let fireSequence = SKAction.sequence([shoot, removeFireBall])
        
        run(fireSequence)
    }
}
