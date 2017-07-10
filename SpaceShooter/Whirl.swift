//
//  Whirl.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 10.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

class Whirl: SKSpriteNode {
    var health = 5
    let textureAtlas = SKTextureAtlas(named: "Whirl")
    var shape: Shape = .folded
    
    enum Shape {
        case folded
        case changing
        case unfolded
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Whirl Folded")
        super.init(texture: texture, color: .clear, size: texture.size())
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startMoving() {
        // Rotation
        let rotation = SKAction.rotate(byAngle: 360 * .pi / 180, duration: 1)
        run(SKAction.repeatForever(rotation))
        
        // Travel
        let xTravelDistance = size.width * 0.1
        let yTravelDistance = size.height * 0.5
        let moveDownAndRight = SKAction.moveBy(x: xTravelDistance, y: -yTravelDistance, duration: 0.4)
        let moveDownAndLeft = SKAction.moveBy(x: -xTravelDistance, y: -yTravelDistance, duration: 0.4)
        let wiggle = SKAction.sequence([moveDownAndLeft, moveDownAndRight])
        run(SKAction.repeatForever(wiggle), withKey: "wiggle")
    }
    
    func unfold() {
        shape = .changing
        let textureAtlas = SKTextureAtlas(named: "Whirl")
        let frames = ["Whirl Folded", "Whirl Almost Folded", "Whirl Almost Unfolded", "Whirl Unfolded"].map { textureAtlas.textureNamed($0) }
        let unfold = SKAction.animate(with: frames, timePerFrame: 0.3)
        self.run(unfold)
        shape = .unfolded
    }
    
//    func update(_ currentTime: TimeInterval) {
//        run(SKAction.rotate(byAngle: 5 * .pi / 180, duration: <#T##TimeInterval#>))
//    }
}
