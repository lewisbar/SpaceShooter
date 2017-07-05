//
//  GameScene+Settings.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 03.07.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit

extension GameScene {
    func startPosition(forNodeWithName name: String) -> CGPoint? {
        switch name {
        case "background": return self.size.center
        case "backgroundEffect": return self.size.center
        case "scoreLabel" : return self.size.center
        case "enemy":
            let enemy = SKSpriteNode(imageNamed: "Raumschiff")
            let enemyStartX = CGFloat(arc4random_uniform(UInt32(self.size.width - 2 * enemy.size.width))) + enemy.size.width
            let enemyStartY = self.size.height + enemy.size.height
            return CGPoint(x: enemyStartX, y: enemyStartY)
        case "fireBall": return spaceship.position
        case "heart1":
            let heart = SKSpriteNode(imageNamed: "Herz")
            return CGPoint(x: 1 * heart.size.width, y: self.size.height - heart.size.height)
        case "heart2":
            let heart = SKSpriteNode(imageNamed: "Herz")
            return CGPoint(x: 2 * heart.size.width, y: self.size.height - heart.size.height)
        case "heart3":
            let heart = SKSpriteNode(imageNamed: "Herz")
            return CGPoint(x: 3 * heart.size.width, y: self.size.height - heart.size.height)
        case "spaceship": return CGPoint(x: self.size.center.x, y: self.size.height * 0.15)
        case "pauseBackground": return self.size.center
        case "pauseLabel": return self.size.center
        default: return nil
        }
    }
    
    func zPosition(forNodeWithName name: String) -> CGFloat? {
        switch name {
        case "background": return 0
        case "backgroundEffect": return 1
        case "scoreLabel" : return 1
        case "enemy": return 2
        case "fireBall": return 2
        case "heart": return 3
        case "spaceship": return 3
        case "explosion": return 4
        case "pauseBackground": return 30
        case "pauseLabel": return 31
        default: return nil
        }
    }
    
    func physicsBody(forNodeWithName name: String) -> SKPhysicsBody? {
        switch name {
        case "spaceship":
            return SKPhysicsBody(rectangleOf: spaceship.size)
        case "fireBall":
            let fireBall = SKSpriteNode(imageNamed: "Sternschuss")
            return SKPhysicsBody(circleOfRadius: fireBall.size.width / 2, center: fireBall.size.center)
        case "enemy":
            let enemy = SKSpriteNode(imageNamed: "Raumschiff")
            return SKPhysicsBody(rectangleOf: enemy.size)
        default: return nil
        }
    }
    
    func isDynamic(forNodeWithName name: String) -> Bool? {
        switch name {
        case "spaceship": return false
        case "fireBall": return false
        case "enemy": return true
        // case "heart1", "heart2", "heart3": return false
        default: return nil
        }
    }
    
    func categoryBitMask(forNodeWithName name: String) -> UInt32? {
        switch name {
        case "spaceship": return 0b1
        case "fireBall": return 0b10
        case "enemy": return 0b100
        default: return nil
        }
    }
    
    func contactTestBitMask(forNodeWithName name: String) -> UInt32? {
        switch name {
        case "spaceship": return 0b100 // enemy
        case "fireBall": return 0b100  // enemy
        case "enemy": return 0b1 | 0b10 // spaceship or fireBall
        default: return nil
        }
    }
}
