//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Lennart Wisbar on 28.06.17.
//  Copyright © 2017 Lennart Wisbar. All rights reserved.
//

import SpriteKit
import AVFoundation

// MARK: - Properties
class GameScene: SKScene {
    // Nodes
    let background = SKSpriteNode(imageNamed: "BackgroundImage.jpg")
    let backgroundEffect = SKEmitterNode(fileNamed: "BackgroundEffect")!
    let spaceship = SKSpriteNode(imageNamed: "Spaceship")
    
    // Sound
    var musicPlayer: AVAudioPlayer?
    
    // Lives
    var liveCount = 0
    var liveArray = [SKSpriteNode]()
    
    // Timers
    var timer1 = Timer()
    var timer2 = Timer()
    
    // Score
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    var scoreLabel = SKLabelNode()
}

// MARK: - Touches
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPaused {
            isPaused = false
            let pauseBackground = childNode(withName: "pauseBackground")
            let pauseLabel = childNode(withName: "pauseLabel")
            
            pauseBackground?.removeFromParent()
            pauseLabel?.removeFromParent()
            musicPlayer?.play()
            
            timer1 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(startSpaceshipFire), userInfo: nil, repeats: true)
            timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPosition = touch.location(in: self)
            spaceship.position.x = touchPosition.x
        }
    }
}

// MARK: Contact
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyBitMasks = [contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask]
        
        if bodyBitMasks.contains(categoryBitMask(forNodeWithName: "fireBall")!),
            bodyBitMasks.contains(categoryBitMask(forNodeWithName: "enemy")!) {
            
            // Explosion
            self.run(SKAction.playSoundFileNamed("ExplosionSound.wav", waitForCompletion: false))
            let explosion = SKEmitterNode(fileNamed: "Explosion.sks")
            explosion?.position = contact.bodyA.node?.name == "enemy" ? (contact.bodyA.node?.position)! : (contact.bodyB.node?.position)!
            explosion?.zPosition = 4
            self.addChild(explosion!)
            
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            self.run(SKAction.wait(forDuration: 2)) {
                explosion?.removeFromParent()
            }
            score += 1
        } else if bodyBitMasks.contains(categoryBitMask(forNodeWithName: "spaceship")!),
            bodyBitMasks.contains(categoryBitMask(forNodeWithName: "enemy")!) {
            
            // Explosion
            self.run(SKAction.playSoundFileNamed("ExplosionSound.wav", waitForCompletion: false))
            let explosion = SKEmitterNode(fileNamed: "Explosion.sks")
            explosion?.position = contact.bodyA.node?.name == "enemy" ? (contact.bodyA.node?.position)! : (contact.bodyB.node?.position)!
            explosion?.zPosition = 4
            self.addChild(explosion!)
            
            if contact.bodyA.node?.name == "enemy" { contact.bodyA.node?.removeFromParent() }
            else { contact.bodyB.node?.removeFromParent() }
            liveArray.popLast()?.removeFromParent()
            spaceship.run(SKAction.repeat(SKAction.sequence([SKAction.fadeAlpha(to: 0.1, duration: 0.1), SKAction.fadeAlpha(to: 1, duration: 0.1)]), count: 10))
            if liveArray.isEmpty {
                gameOver()
            }
        }
    }
    
    func gameOver() {
        timer1.invalidate()
        timer2.invalidate()
        musicPlayer?.stop()
        
        let explosion = SKEmitterNode(fileNamed: "SpaceshipExplosion")
        explosion?.zPosition = 4
        explosion?.position = spaceship.position
        self.addChild(explosion!)
        spaceship.removeFromParent()
        self.run(SKAction.wait(forDuration: 1)) {
            let gameOverScene = GameOver(size: self.size)
            let transition = SKTransition.crossFade(withDuration: 1)
            self.view?.presentScene(gameOverScene, transition: transition)
        }
    }
}
