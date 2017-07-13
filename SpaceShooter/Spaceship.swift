//
//  Spaceship.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 13.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode, SpaceSprite {
    
    var delegate: SpaceshipLifeCountDelegate?
    var health = 3 {
        didSet {
            delegate?.healthPointsChanged(to: health)
        }
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Spaceship")
        super.init(texture: texture, color: .clear, size: texture.size())
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SpaceshipLifeCountDelegate {
    func healthPointsChanged(to health: Int)
}
